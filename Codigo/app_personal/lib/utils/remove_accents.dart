String removeAccents(String text) {
  const accents = 'áàãâäéèêëíìîïóòõôöúùûüçÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇ';
  const withoutAccents = 'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC';

  for (int i = 0; i < accents.length; i++) {
    text = text.replaceAll(accents[i], withoutAccents[i]);
  }
  return text;
}
