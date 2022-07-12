String typeConvert(String? type) {
  if (type == 'villa') {
    return "ویلای";
  } else if (type == 'apartment') {
    return "آپارتمان";
  } else if (type == 'commercial') {
    return "تجاری";
  } else if (type == 'land') {
    return "زمین";
  } else if (type == 'hectare') {
    return "هکتاری";
  } else {
    return "";
  }
}

List<String> documentsListTypes = [
  "تک برگ",
  "شش دانگ",
  "بنچاق",
  "مشاع",
  "قولنامه ای",
  "شورایی",
  "بنیادی",
  "اوقاف",
  "شاهی",
  "دفترچه ای",
  "در دست اقدام",
];

List<String> apartmentEquipmentsList = [
  "انباری",
  "پارکینگ",
  "آسانسور",
  "سونا",
  "جکوزی",
  "مبله",
  "کمد دیواری",
  "ویو",
];

List<String> villaEquipmentsList = [
  "آسانسور",
  "استخر",
  "حیاط سازی",
  "روف گاردن",
  "جکوزی",
  "سونا",
  "ساحلی",
  "جنگلی",
  "شهرکی",
  "شاه نشین",
  "فول",
  "فرنیش",
];

const List<String> usageStatusLandHectare = [
  "مسکونی",
  "زراعی و کشاورزی",
  "جنگل جلگه ای",
  "اداری و تجاری",
  "ساحلی",
  "تفریحی توریستی",
  "باغات",
  "ذخیره شهری",
];

const tissueStatusLandHectare = [
  "داخل بافت",
  "الحاق به بافت",
  "خارج بافت",
];

const commercialTypesItems = [
  "اداری",
  "تجاری",
  "مغازه",
  "صنعتی",
  "دامداری و کشاورزی",
  "مسکونی",
];
/*

ل / نشی ن شا ه /شهرکی / جنگلی / ساحلی / سون ا / جکوز ی / گاردن روف / سازی حیا ط /  / 
*/
