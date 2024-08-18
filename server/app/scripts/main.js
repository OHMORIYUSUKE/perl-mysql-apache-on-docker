function updatePath() {
  var form = document.getElementById("search-form");
  var action = "/index.cgi/search/";

  // 各フィールドから値を取得
  var params = [
    { id: "ch_name", name: "ch-name" },
    { id: "cv_name", name: "cv-name" },
    { id: "ch_blood_type", name: "ch-blood-type" },
    { id: "group", name: "group" },
  ]
    .map((field) => {
      var value = document.getElementById(field.id).value;
      return value ? `${field.name}/${encodeURIComponent(value)}` : null;
    })
    .filter((param) => param !== null)
    .join("/");

  // URL を変更し、フォームを送信
  history.pushState(null, "", action + params);
  form.action = action + params;
  form.submit();
}
