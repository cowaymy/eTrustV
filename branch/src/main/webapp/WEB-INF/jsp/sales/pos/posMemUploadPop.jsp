<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css" >

/* 커스텀 행 스타일 */
.aui-grid-body-panel .aui-grid-table tr .brnch-not-mach div{
    
    font-weight:bold;
    color:#ff0000;
}
    
</style>
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
         Common.alert('<spring:message code="sal.alert.msg.notSupportBrowser" />');
         return;
     } else {
         var data = null;
         var file = evt.target.files[0];
         if (typeof file == "undefined") {
             Common.alert('<spring:message code="sal.alert.msg.canNotSelectFile" />');
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

             setAUIGrid( jsonObj[Object.keys(jsonObj)[0]] );
         };

         if(rABS) reader.readAsBinaryString(file);
         else reader.readAsArrayBuffer(file);
         
     }
 });

 //Member Delete
 $("#_memDelBtn").click(function() {
	 AUIGrid.removeCheckedRows(myGridID);
	 
	 var rowCnt = AUIGrid.getRowCount(myGridID);
	 //console.log("rowCnt : " + rowCnt);
	 if(rowCnt <= 0){
		 $("#fileSelector").val("");
	 }
 });
 
 //Member Save
 $("#_memSaveBtn").click(function() {
	
	//Validation
	//1. Grid Null Check
	 var gridCnt = AUIGrid.getRowCount(myGridID);
     //console.log("rowCnt : " + rowCnt);
     if(gridCnt <= 0){
         Common.alert('<spring:message code="sal.alert.msg.noMembershipSelect" />');
         return;
     }
	
	//2. Brnch Check
	 var branchArr  = AUIGrid.getColumnValues(myGridID, 'brnch');
	 var mainBrnch = $("#_mainBrnch").val();
	 var chkBrnch = true;
	 var idxNo = 0;
	 var itemObj;
	 var validMemCodeArr = [];
	 var validMemList = "";
	$.each(branchArr ,function(index, el) {
		if(el != mainBrnch){
			
			itemObj =AUIGrid.getItemByRowIndex(myGridID, idxNo);
			validMemCodeArr.push(itemObj.memCode);
		}
	});
	if( null != validMemCodeArr && validMemCodeArr.length > 0){
		validMemList = validMemCodeArr.toString();
		Common.alert('<spring:message code="sal.alert.msg.notValidMemForBrnch"  arguments="'+validMemList+'"/>');
		return;
	}
	 
	//Validation Success
	var moveObj = AUIGrid.getGridData(myGridID);
	fn_setMemberGirdData(moveObj);
	$("#_memUpPopClose").click();
	
	//Insert Grid
	 
 });
});//Doc Ready Func End


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

function setAUIGrid(jsonData) {
 
 var firstRow = jsonData;
 
 if(typeof firstRow == "undefined") {
     Common.alert('<spring:message code="sal.alert.msg.canNotConvReTry" />');
     $("#fileSelector").val("");
     return;
 }
 
	var memIdArray = [];
	$.each(jsonData, function(key , value) {
	  $.each(value, function(k, v) {
			//console.log("key : " + k)
			if(k.trim() == "MEMBER_CODE"){  //Template
				memIdArray.push(v);
			}
	  });
	});

	//template Chk
	if(memIdArray == null || memIdArray.length <= 0){
		Common.alert('<spring:message code="sal.alert.msg.TemplChngReTry" />');
		$("#fileSelector").val("");
		return;
	}
     // 코드 리스트들
    //console.log("memIdArray : " + memIdArray);
  
	 //Ajax 로 데이터 가져오기
	 var jsonParam = { memIdArray : memIdArray};
	 Common.ajax("GET", "/sales/pos/getUploadMemList", jsonParam , function(result) {
		 
		 if(result == null){
			 Common.alert('<spring:message code="sal.alert.msg.memNotFound2" />');
			 $("#fileSelector").val("");
			 return;
		 }else{
			 
		//	 console.log("result.length : " + result.length);  // from DB
		//	 console.log("jsonData.length : " + jsonData.length); //from EXEL
			  if(result.length != jsonData.length){
				
				  if(result.length >  jsonData.length){
					  Common.alert('<spring:message code="sal.alert.msg.conflicMemId" />');
					  return;
				  }
				  
				  //Params Setting
				  var strArr = [];
				  var rtnMemArr = [];
				  var rtnMemList = "";
				  
                  for (var idx = 0; idx < result.length; idx++) {
                     strArr.push(result[idx].memCode);   
                  }
                  
			//	  console.log("memIdArray : "+ memIdArray);  //jsonData  from EXEL
			//	  console.log("strArr : " + strArr);  //result from DB
				  
				  $.each(memIdArray, function(idx, el) {
					
					  if(strArr.indexOf(el) == -1){
						  //console.log("el : " + el);
						  rtnMemArr.push(el);
					  }
				  });
				  rtnMemList = rtnMemArr.toString();
				  Common.alert('<spring:message code="sal.alert.msg.memNotValid" />');
				  $("#fileSelector").val("");
				  return;
			 }
			 AUIGrid.setGridData(myGridID, result);
		 }
	 });
}; //Create Grid End


//최초 그리드 생성..
function createInitGrid() {
 
   var columnLayout = [
			                     {dataField : "memId" , headerText : '<spring:message code="sal.title.memberId" />', width : "20%",  editable : false },
			                     {dataField : "memCode" , headerText : '<spring:message code="sal.title.memberCode" />', width : "20%",  editable : false },
			                     {dataField : "name" , headerText : '<spring:message code="sal.title.memberName" />', width : "20%",  editable : false },
			                     {dataField : "nric" , headerText : '<spring:message code="sal.title.memberNRIC" />', width : "20%",  editable : false },
			                     {dataField : "code" , headerText : '<spring:message code="sal.text.branch" />', width : "20%",  editable : false },
			                     {dataField : "brnch" , visible : false},
			                     {dataField : "memType" , visible : false},
			                     {dataField : "fullName" , visible : false},
			                     {dataField : "stus" , visible : false}
                               ];
	var gridPros = {
		showRowCheckColumn : true, //checkBox
		softRemoveRowMode : false, 
		rowStyleFunction : function(rowIndex, item){
		  //console.log("memCode : " + item.memCode + " , brnch : " + item.brnch + " Main Brnch : " + $("#_mainBrnch").val());
		  if(item.brnch != $("#_mainBrnch").val()){
		      return "brnch-not-mach";
		  }
		  return "";
		}
	};
 myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
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
<input type="hidden" id="_mainBrnch"  value="${mainBrnch}">
<header class="pop_header"><!-- pop_header start -->
<h1>Member Upload</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_memUpPopClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="${pageContext.request.contextPath}/resources/download/sales/PosMemberUploadTemplate.xlsx"><spring:message code="sal.btn.template" /></a></p></li>
</ul>

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.uploadFile" /></th>
    <td>
    <div class="auto_file2"><!-- auto_file start -->
    <input type="file" title="file add"  id="fileSelector" accept=".xlsx" />
    </div><!-- auto_file end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.memList" /></h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a id="_memDelBtn"><spring:message code="sal.btn.del" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap" style="width:800px; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_memSaveBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->