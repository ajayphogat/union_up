
class IssueListModel {
  int? id;
  String? date;
  String? dateGmt;
  Guid? guid;
  String? modified;
  String? modifiedGmt;
  String? slug;
  String? status;
  String? type;
  String? category;
  String? link;
  Guid? title;
  Content? content;
  String? template;
  Meta? meta;
  List<String>? acf;
  String? issuePriority;
  String? issueStatus;
  String? issueArchive;
  Links? lLinks;

  IssueListModel(
      {this.id,
        this.date,
        this.dateGmt,
        this.guid,
        this.modified,
        this.modifiedGmt,
        this.slug,
        this.status,
        this.type,
        this.category,
        this.link,
        this.title,
        this.content,
        this.template,
        this.meta,
        this.acf,
        this.issuePriority,
        this.issueStatus,
        this.issueArchive,
        this.lLinks});

  IssueListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    guid = json['guid'] != null ? new Guid.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    slug = json['slug'];
    status = json['status'];
    type = json['type'];
    category = json['category'];
    link = json['link'];
    title = json['title'] != null ? new Guid.fromJson(json['title']) : null;
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    template = json['template'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    acf = json['acf'].cast<String>();
    issuePriority = json['issue_priority'];
    issueStatus = json['issue_status'];
    issueArchive = json['issue_archive'];
    lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['date_gmt'] = this.dateGmt;
    if (this.guid != null) {
      data['guid'] = this.guid!.toJson();
    }
    data['modified'] = this.modified;
    data['modified_gmt'] = this.modifiedGmt;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['type'] = this.type;
    data['category'] = this.category;
    data['link'] = this.link;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    data['template'] = this.template;
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    data['acf'] = this.acf;
    data['issue_priority'] = this.issuePriority;
    data['issue_status'] = this.issueStatus;
    data['issue_archive'] = this.issueArchive;
    if (this.lLinks != null) {
      data['_links'] = this.lLinks!.toJson();
    }
    return data;
  }
}

class Guid {
  String? rendered;

  Guid({this.rendered});

  Guid.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    return data;
  }
}

class Content {
  String? rendered;
  bool? protected;

  Content({this.rendered, this.protected});

  Content.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    protected = json['protected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    data['protected'] = this.protected;
    return data;
  }
}

class Meta {
  bool? bAcfChanged;

  Meta({this.bAcfChanged});

  Meta.fromJson(Map<String, dynamic> json) {
    bAcfChanged = json['_acf_changed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_acf_changed'] = this.bAcfChanged;
    return data;
  }
}

class Links {
  List<Self>? self;
  List<Self>? collection;
  List<Self>? about;
  List<Self>? wpAttachment;
  List<Curies>? curies;

  Links(
      {this.self, this.collection, this.about, this.wpAttachment, this.curies});

  Links.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = <Self>[];
      json['self'].forEach((v) {
        self!.add(new Self.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = <Self>[];
      json['collection'].forEach((v) {
        collection!.add(new Self.fromJson(v));
      });
    }
    if (json['about'] != null) {
      about = <Self>[];
      json['about'].forEach((v) {
        about!.add(new Self.fromJson(v));
      });
    }
    if (json['wp:attachment'] != null) {
      wpAttachment = <Self>[];
      json['wp:attachment'].forEach((v) {
        wpAttachment!.add(new Self.fromJson(v));
      });
    }
    if (json['curies'] != null) {
      curies = <Curies>[];
      json['curies'].forEach((v) {
        curies!.add(new Curies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.self != null) {
      data['self'] = this.self!.map((v) => v.toJson()).toList();
    }
    if (this.collection != null) {
      data['collection'] = this.collection!.map((v) => v.toJson()).toList();
    }
    if (this.about != null) {
      data['about'] = this.about!.map((v) => v.toJson()).toList();
    }
    if (this.wpAttachment != null) {
      data['wp:attachment'] =
          this.wpAttachment!.map((v) => v.toJson()).toList();
    }
    if (this.curies != null) {
      data['curies'] = this.curies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}

class Curies {
  String? name;
  String? href;
  bool? templated;

  Curies({this.name, this.href, this.templated});

  Curies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    href = json['href'];
    templated = json['templated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['href'] = this.href;
    data['templated'] = this.templated;
    return data;
  }
}