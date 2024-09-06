class CommentModel {
  String? status;
  String? message;
  List<CommentData>? data;

  CommentModel({this.status, this.message, this.data});

  CommentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CommentData>[];
      json['data'].forEach((v) {
        data!.add(new CommentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentData {
  String? id;
  String? commentPostID;
  String? commentAuthor;
  String? commentAuthorEmail;
  String? commentAuthorIP;
  String? commentAuthorUrl;
  String? commentDate;
  String? commentDateGmt;
  String? commentContent;
  String? commentKarma;
  String? commentApproved;
  String? commentAgent;
  String? commentType;
  String? commentParent;
  String? userId;
  String? userImage;
  List<CommentMeta>? commentMeta;
  List<Replies>? replies;

  CommentData(
      {this.id,
        this.commentPostID,
        this.commentAuthor,
        this.commentAuthorEmail,
        this.commentAuthorIP,
        this.commentAuthorUrl,
        this.commentDate,
        this.commentDateGmt,
        this.commentContent,
        this.commentKarma,
        this.commentApproved,
        this.commentAgent,
        this.commentType,
        this.commentParent,
        this.userId,
        this.userImage,
        this.commentMeta,
        this.replies});

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentPostID = json['comment_post_ID'];
    commentAuthor = json['comment_author'];
    commentAuthorEmail = json['comment_author_email'];
    commentAuthorIP = json['comment_author_IP'];
    commentAuthorUrl = json['comment_author_url'];
    commentDate = json['comment_date'];
    commentDateGmt = json['comment_date_gmt'];
    commentContent = json['comment_content'];
    commentKarma = json['comment_karma'];
    commentApproved = json['comment_approved'];
    commentAgent = json['comment_agent'];
    commentType = json['comment_type'];
    commentParent = json['comment_parent'];
    userId = json['user_id'];
    userImage = json['user_image'];
    if (json['comment_meta'] != null) {
      commentMeta = <CommentMeta>[];
      json['comment_meta'].forEach((v) {
        commentMeta!.add(new CommentMeta.fromJson(v));
      });
    }
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_post_ID'] = this.commentPostID;
    data['comment_author'] = this.commentAuthor;
    data['comment_author_email'] = this.commentAuthorEmail;
    data['comment_author_IP'] = this.commentAuthorIP;
    data['comment_author_url'] = this.commentAuthorUrl;
    data['comment_date'] = this.commentDate;
    data['comment_date_gmt'] = this.commentDateGmt;
    data['comment_content'] = this.commentContent;
    data['comment_karma'] = this.commentKarma;
    data['comment_approved'] = this.commentApproved;
    data['comment_agent'] = this.commentAgent;
    data['comment_type'] = this.commentType;
    data['comment_parent'] = this.commentParent;
    data['user_id'] = this.userId;
    data['user_image'] = this.userImage;
    if (this.commentMeta != null) {
      data['comment_meta'] = this.commentMeta!.map((v) => v.toJson()).toList();
    }
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentMeta {
  String? metaId;
  String? metaKey;
  String? metaValue;

  CommentMeta({this.metaId, this.metaKey, this.metaValue});

  CommentMeta.fromJson(Map<String, dynamic> json) {
    metaId = json['meta_id'];
    metaKey = json['meta_key'];
    metaValue = json['meta_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meta_id'] = this.metaId;
    data['meta_key'] = this.metaKey;
    data['meta_value'] = this.metaValue;
    return data;
  }
}

class Replies {
  String? id;
  String? commentPostID;
  String? commentAuthor;
  String? commentAuthorEmail;
  String? commentAuthorIP;
  String? commentAuthorUrl;
  String? commentDate;
  String? commentDateGmt;
  String? commentContent;
  String? commentKarma;
  String? commentApproved;
  String? commentAgent;
  String? commentType;
  String? commentParent;
  String? userId;
  List<CommentMeta>? commentMeta;

  Replies(
      {this.id,
        this.commentPostID,
        this.commentAuthor,
        this.commentAuthorEmail,
        this.commentAuthorIP,
        this.commentAuthorUrl,
        this.commentDate,
        this.commentDateGmt,
        this.commentContent,
        this.commentKarma,
        this.commentApproved,
        this.commentAgent,
        this.commentType,
        this.commentParent,
        this.userId,
        this.commentMeta});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentPostID = json['comment_post_ID'];
    commentAuthor = json['comment_author'];
    commentAuthorEmail = json['comment_author_email'];
    commentAuthorIP = json['comment_author_IP'];
    commentAuthorUrl = json['comment_author_url'];
    commentDate = json['comment_date'];
    commentDateGmt = json['comment_date_gmt'];
    commentContent = json['comment_content'];
    commentKarma = json['comment_karma'];
    commentApproved = json['comment_approved'];
    commentAgent = json['comment_agent'];
    commentType = json['comment_type'];
    commentParent = json['comment_parent'];
    userId = json['user_id'];
    if (json['comment_meta'] != null) {
      commentMeta = <CommentMeta>[];
      json['comment_meta'].forEach((v) {
        commentMeta!.add(new CommentMeta.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_post_ID'] = this.commentPostID;
    data['comment_author'] = this.commentAuthor;
    data['comment_author_email'] = this.commentAuthorEmail;
    data['comment_author_IP'] = this.commentAuthorIP;
    data['comment_author_url'] = this.commentAuthorUrl;
    data['comment_date'] = this.commentDate;
    data['comment_date_gmt'] = this.commentDateGmt;
    data['comment_content'] = this.commentContent;
    data['comment_karma'] = this.commentKarma;
    data['comment_approved'] = this.commentApproved;
    data['comment_agent'] = this.commentAgent;
    data['comment_type'] = this.commentType;
    data['comment_parent'] = this.commentParent;
    data['user_id'] = this.userId;
    if (this.commentMeta != null) {
      data['comment_meta'] = this.commentMeta!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}