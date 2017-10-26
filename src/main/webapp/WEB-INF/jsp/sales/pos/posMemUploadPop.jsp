<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

var myGridID;

// document ready 
$(document).ready(function() { 

  //InputFile Enable
  setInputFile2();
	
 // 최초 그리드 생성함.
 createInitGrid();
 
 // IE10, 11은 readAsBinaryString 지원을 안함. 따라서 체크함.
 var rABS = typeof FileReader !== "undefined" && typeof FileReader.prototype !== "undefined" && typeof FileReader.prototype.readAsBinaryString !== "undefined";

 // HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
 function checkHTML5Brower() {
     var isCompatible = false;
     if (window.File && window.FileReader && window.FileList && window.Blob) {
         isCompatible = true;
     }
     return isCompatible;
 };
 
 // 파일 선택하기
 $('#fileSelector').on('change', function(evt) {
     if (!checkHTML5Brower()) {
         Common.alert("* Not Support HTML5 your Browser!. Please Upload To Server.");
         return;
     } else {
         var data = null;
         var file = evt.target.files[0];
         if (typeof file == "undefined") {
             Common.alert("* can not Select this File.");
             return;
         }
         var reader = new FileReader();

         reader.onload = function(e) {
             var data = e.target.result;

             /* 엑셀 바이너리 읽기 */
             var workbook;

             if(rABS) { // 일반적인 바이너리 지원하는 경우
                 workbook = XLSX.read(data, {type: 'binary'});
             } else { // IE 10, 11인 경우
                 var arr = fixdata(data);
                 workbook = XLSX.read(btoa(arr), {type: 'base64'});
             }

             var jsonObj = process_wb(workbook);

             createAUIGrid( jsonObj[Object.keys(jsonObj)[0]] );
         };

         if(rABS) reader.readAsBinaryString(file);
         else reader.readAsArrayBuffer(file);
         
     }
 });

});

// IE10, 11는 바이너리스트링 못읽기 때문에 ArrayBuffer 처리 하기 위함.
function fixdata(data) {
 var o = "", l = 0, w = 10240;
 for(; l<data.byteLength/w; ++l) o+=String.fromCharCode.apply(null,new Uint8Array(data.slice(l*w,l*w+w)));
 o+=String.fromCharCode.apply(null, new Uint8Array(data.slice(l*w)));
 return o;
};

// 파싱된 시트의 CDATA 제거 후 반환.
function process_wb(wb) {
 var output = "";
 output = JSON.stringify(to_json(wb));

 output = output.replace( /<!\[CDATA\[(.*?)\]\]>/g, '$1' );
 return JSON.parse(output);
};

// 엑셀 시트를 파싱하여 반환
function to_json(workbook) {
 var result = {};
 workbook.SheetNames.forEach(function(sheetName) {
     var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName], {defval:""});
     
     if(roa.length > 0){
         result[sheetName] = roa;
     }
 });
 return result;
}

// 엑셀 파일 시트에서 파싱한 JSON 데이터 기반으로 그리드 동적 생성
function createAUIGrid(jsonData) {
 if(AUIGrid.isCreated(myGridID)) {
     AUIGrid.destroy(myGridID);
     myGridID = null;
 }
 
 var firstRow = jsonData;
 
 if(typeof firstRow == "undefined") {
     Common.alert("* Can Convert File. Please Try Again.");
     return;
 }
 
  var memIdArray = [];
  $.each(jsonData, function(key , value) {
	$.each(value, function(k, v) {
		console.log("key : " + k)
		if(k.trim() == "MEMBERID"){  //Template
			memIdArray.push(v);
		}
	})
	
});

//template Chk
if(memIdArray == null || memIdArray.length <= 0){
	Common.alert("* Template was Chaged. Please Try Again. ");
	return;
}
  // 코드 리스트들
console.log("memIdArray : " + memIdArray);
  
 //Ajax 로 데이터 가져오기
 var jsonParam = { memIdArray : memIdArray};
 Common.ajax("GET", "/sales/pos/getUploadMemList", jsonParam , function(result) {
	 
	 if(result == null){
		 Common.alert('<b>Member not found.</br>');
	 }else{
		 console.log("Ajax 는 성공");
		 console.log("내용 : " + JSON.stringify(result));
		 var columnLayout = [
		                                  {dataField : "memId" , headerText : "Member ID", width : "20%",  editable : false },
		                                  {dataField : "memCode" , headerText : "Member Code", width : "20%",  editable : false },
		                                  {dataField : "name" , headerText : "Member NAme", width : "20%",  editable : false },
		                                  {dataField : "nric" , headerText : "Member NRIC", width : "20%",  editable : false },
		                                  {dataField : "code" , headerText : "Branch", width : "20%",  editable : false },
		                                  {dataField : "brnch" , visible : true}
		                             ]
		 
		 myGridID = AUIGrid.create("#grid_wrap", columnLayout);
		 AUIGrid.setGridData(myGridID, result);
		 
		//그릴때 혹은 그리고 나서 혹은 세이브시 브랜치 비교해서 컬럼 색 바꾸기
		
		//UPLOAD 파일의 길이와 그리드에 그려진 리스트 길이 비교하기
		 
	 }
	 
 });
 //가져온 데이터로 그리드 그리기
 
 

/*  $.each(firstRow, function(n,v) {
     console.log(" n : " + n + " , v : " + v);
	 columnLayout.push({
         dataField : n,
         headerText : n,
         width : 100
     });
 }); */
 
 // 그리드 생성
 //myGridID = AUIGrid.create("#grid_wrap", columnLayout);
 
 // 그리드에 데이터 삽입
// AUIGrid.setGridData(myGridID, jsonData);

};


//최초 그리드 생성..
function createInitGrid() {
 
 var columnLayout = [];
 
 for(var i=0; i<10; i++) {
     columnLayout.push({
         dataField : "f" + i,
         headerText : String.fromCharCode(65 + i),
         width : 80
     });
 }
 
 // 그리드 속성 설정
 var gridPros = {
     noDataMessage : "로컬 PC의 엑셀 파일을 선택하십시오."
 };

 // 실제로 #grid_wrap 에 그리드 생성
 myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
 
 // 그리드 최초에 빈 데이터 넣음.
 AUIGrid.setGridData(myGridID, []);
}

//아이템들 확인하기
/* function checkItems() {

 var itemsObject = AUIGrid.exportToObject("#grid_wrap");
 //alert(itemsObject);
 alert(JSON.stringify(itemsObject));
} */

//서버로 전송.
/* function fn_saveSampleGridData(){
 Common.ajax("POST", "/sample/saveSampleGridData.do", AUIGrid.exportToObject("#grid_wrap"), function(result) { 
     alert("성공");
     console.log("성공.");
     console.log("data : " + result);
 },  function(jqXHR, textStatus, errorThrown) {
     try {
         console.log("status : " + jqXHR.status);
         console.log("code : " + jqXHR.responseJSON.code);
         console.log("message : " + jqXHR.responseJSON.message);
         console.log("detailMessage : "
                 + jqXHR.responseJSON.detailMessage);
     } catch (e) {
         console.log(e);
     }

     alert("Fail : " + jqXHR.responseJSON.message);
 });
} */

function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Delete</a></span>");
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Member Upload</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="#">Template</a></p></li>
</ul>

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Upload File</th>
    <td>
    <div class="auto_file2"><!-- auto_file start -->
    <input type="file" title="file add"  id="fileSelector" accept=".xlsx" value="sadfasdf"/>
    </div><!-- auto_file end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Member List</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap" style="width:800px; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Save</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->