abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

class ChatLoadState extends ChatStates {}

class ChatSuccessState extends ChatStates {}

class ChatErrorState extends ChatStates {}

class MessageSendLoadState extends ChatStates {}

class MessageSendSuccessState extends ChatStates {}

class MessageSendErrorState extends ChatStates {}

class ChangeScreenState extends ChatStates {}
