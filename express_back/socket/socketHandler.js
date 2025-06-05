const jwt = require('jsonwebtoken');
const User = require('../models/User'); // تغییر مسیر به 
const Message = require('../models/Message'); // تغییر مسیر به 

// تابع برای مدیریت سوکت
const socketHandler = (io) => {
  // میدلور احراز هویت برای Socket.IO
  io.use((socket, next) => {
    const token = socket.handshake.auth.token || socket.handshake.query.token;
    console.log('Received token:', token);
    if (!token) {
      socket.emit('error', 'Authentication error: No token provided');
      return next(new Error('Authentication error: No token provided'));
    }
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      console.log('Decoded token:', decoded);
      if (!decoded.id) {
        throw new Error('Token does not contain id');
      }
      socket.user = decoded;
      console.log('Authenticated user:', decoded);
      next();
    } catch (err) {
      const errorMsg = err.name === 'TokenExpiredError' ? 'Token expired! Please login again.' : `Invalid token: ${err.message}`;
      console.error('Authentication error:', err.message);
      socket.emit('error', errorMsg);
      return next(new Error(`Authentication error: ${errorMsg}`));
    }
  });

  io.on('connection', (socket) => {
    console.log('New client connected:', socket.user);

    if (!socket.user || !socket.user.id) {
      console.log('Invalid user data, disconnecting:', socket.user);
      socket.emit('error', 'Authentication failed: Invalid user data');
      return socket.disconnect(true);
    }

    socket.on('getChatPartners', async () => {
      const senderId = socket.user.id.toString();
      const user = await User.findOne({ userId: senderId });
      socket.emit('chatPartners', user?.chatPartners || []);
    });
    

    socket.on('join', async ({ receiverId }) => {
      const senderId = socket.user.id.toString();
      if (!receiverId) {
        return socket.emit('error', 'receiverId الزامی است');
      }

      const room = [senderId, receiverId].sort().join('_');
      socket.join(room);

      await User.findOneAndUpdate(
        { userId: senderId },
        { userId: senderId, username: `User_${senderId}`, $addToSet: { chatPartners: receiverId } },
        { upsert: true }
      );
      await User.findOneAndUpdate(
        { userId: receiverId },
        { userId: receiverId, username: `User_${receiverId}`, $addToSet: { chatPartners: senderId } },
        { upsert: true }
      );

      const user = await User.findOne({ userId: senderId });
      socket.emit('chatPartners', user.chatPartners);

      const messages = await Message.find({
        $or: [
          { sender: senderId, receiver: receiverId },
          { sender: receiverId, receiver: senderId },
        ],
      }).sort({ timestamp: 1 });
      socket.emit('loadMessages', messages);
    });

    socket.on('sendMessage', async ({ receiverId, message }) => {
      const senderId = socket.user.id.toString();
      if (!receiverId || !message) {
        return socket.emit('error', 'receiverId و message الزامی هستند');
      }

      const room = [senderId, receiverId].sort().join('_');
      const newMessage = new Message({
        sender: senderId,
        receiver: receiverId,
        message,
      });
      await newMessage.save();

      io.to(room).emit('receiveMessage', newMessage);
    });

    socket.on('disconnect', () => {
      console.log('Client disconnected:', socket.user);
    });
  });
};

module.exports = socketHandler;