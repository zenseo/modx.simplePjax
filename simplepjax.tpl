/*<?php*/
/**
 * simplepjax
 * <strong>1.0</strong> pjaxリクエスト時にテンプレートを変更します
 * @internal @events OnLoadWebDocument
 * @internal @properties &templates=テンプレートの変更ルール<br>普通の＝pjax用(ｲｺｰﾙは小文字)(例：10＝11,12＝13);text;
 */

if ($modx->event->name !== 'OnLoadWebDocument') return;
if (!$templates) return;

$header = getallheaders();
if ($header['X-PJAX']) {
	//if ($_GET['_pjax']) {
	$templates = explode(',', $templates);
	$rules = array();
	foreach ($templates as $val) {
		$item = explode('=', $val);
		$rules[$item[0]] = $item[1];
	}
	$old_tid = $modx->documentObject['template'];
	$new_tid = null;
	if (array_key_exists($old_tid, $rules)) {
		$new_tid = intval($rules[$old_tid]);
	}
	if (is_null($new_tid)) return;

	$table = $modx->getFullTableName('site_templates');
	$result = $modx->db->select("id, content", $table, "id= '". $new_tid ."'");
	if($modx->db->getRecordCount($result) == 1) {
		$row = $modx->db->getRow($result);
		$modx->documentObject['template'] = $row['id'];
		$modx->documentContent = $row["content"];
	} else {
		$this->messageQuit('Template is not found.');
	}
}