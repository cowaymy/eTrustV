<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">




//AUIGrid  ID
var mstGridID;

//flag
var isExcelUploadFlag =false;

$(document).ready(function(){


	/*get combo data */
	doGetComboData('/logistics/sro/selectSroCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'loctype', 'M','f_multiCombo');

	var stockgradecomboData = [{"codeId": "A","codeName": "A"}];
    doDefCombo(stockgradecomboData, '' ,'locgrad', 'S', 'f_multiCombo');

    doGetCombo('/common/selectCodeList.do', '11', '','catetype', 'M' , 'f_multiCombo');
    doGetCombo('/common/selectCodeList.do', '15', '', 'cType', 'M','f_multiCombo');

    createAUIGrid(columnLayout);

});



var groupList = [" ", "A", "B", "C" ];
var groupYnList = ["Y", "N" ];

var columnLayout = [
                    {dataField: "loccd",headerText :"Location Code"                                         ,width:  110   ,height:30 , visible:true, editable : false},
                    {dataField: "locdesc",headerText :"Location Name"       ,width: 180    ,height:30 , visible:true, editable : false},
                    {dataField: "matcd",headerText :"Mat.Code"          ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "matname",headerText :"Mat.Name"          ,width:220   ,height:30 , visible:true, editable : false},
                    {dataField: "basicqty",headerText :"Basic Qty"          ,width:120   ,height:30 , visible:true, editable : true},
                    {dataField: "reoderpoint",headerText :"ReOrderPoint"          ,width:140   ,height:30 , visible:true ,editable : true},
                    //{dataField: "additional",headerText :"Additional"          ,width:120   ,height:30 , visible:false,editable : true},
                    /* {dataField: "loclevl",headerText :"Location Level"  ,width:120   ,height:30 , visible:false ,
                        editRenderer : {
                            type : "ComboBoxRenderer",
                            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                            list : groupList
                        }
                    } ,*/
                    {dataField: "useyn",headerText :"Use YN"  ,width:80   ,height:30 , visible:true ,
                        editRenderer : {
                            type : "ComboBoxRenderer",
                            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                            list : groupYnList
                        }
                    }

           ];




createAUIGrid =function(columnLayout ){


	   var resop = { editable:true};

	    mstGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);

	  // 에디팅 시작 이벤트 바인딩
	    AUIGrid.bind(mstGridID, "cellEditBegin", auiCellEditingHandler);

	    // 에디팅 정상 종료 이벤트 바인딩
	    AUIGrid.bind(mstGridID, "cellEditEnd", auiCellEditingHandler);

	    // 에디팅 취소 이벤트 바인딩
	    AUIGrid.bind(mstGridID, "cellEditCancel", auiCellEditingHandler);


}


auiCellEditingHandler= function(event)    {
	    if(event.type == "cellEditBegin") {
	        //$("#editBeginDesc").text("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	    } else if(event.type == "cellEditEnd") {
	        //$("#editBeginEnd").text("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	    } else if(event.type == "cellEditCancel") {
	        //$("#editBeginEnd").text("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	    }
}



f_multiCombo = function (){

	 $('#loctype').change(function() {
        	paramdata = {stoIn: eval("'"+$("#loctype").val()+"'")  , grade:$("#locgrad").val() };
            $("#locgrad").val("A");
            doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '','tlocation', 'S' , '');
       }).multipleSelect({
            selectAll: true, // 전체선택
            width: '80%'
       });

	 $('#locgrad').change(function() {
		 paramdata = {stoIn: eval("'"+$("#loctype").val()+"'")  , grade:$("#locgrad").val() }; // session 정보 등록
	     doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '','tlocation', 'S' , '');
	 });

	  $('#catetype').change(function() {

      }).multipleSelect({
          selectAll : true
      });//.multipleSelect("checkAll");

      $('#cType').change(function() {

      }).multipleSelect({
          selectAll : true
      });//.multipleSelect("checkAll");

}


// 리스트 조회.
fn_getDataListAjax  = function () {


     Common.ajax("GET", "/logistics/sro/sroItemMgmtList.do", $("#searchForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
       // console.log(result);
        AUIGrid.setGridData(mstGridID, result);
    });
}



fn_gridExport =function (type){

	/*
	  var excelProps = {

	        sheetName : "숨겨진 칼럼은 제외 시킨 엑셀",

	        //exceptColumnFields : ["name", "product", "color"] // 이름, 제품, 컬러는 아예 엑셀로 내보내기 안하기.

	         //현재 그리드의 히든 처리된 칼럼의 dataField 들 얻어 똑같이 동기화 시키기
	        exceptColumnFields : AUIGrid.getHiddenColumnDataFields(mstGridID)
	    };


	    AUIGrid.exportToXlsx(mstGridID, excelProps);
	    */

    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap", type, "sro_item_excel");
}


fn_validation =function(){

	// 수정, 추가한 행에 대하여 검사
    // name 과 country 는 필수로 입력되어야 하는 필드임. 이것을 검사
   // var isValid = AUIGrid.validateChangedGridData(myGridID, ["name", "country"], "반드시 유효한 값을 직접 입력해야 합니다.");
    return true;
}



fn_save =function (){

	var param  =  {};
    param.add = AUIGrid.exportToObject("#grid_wrap");

    console.log(GridCommon.getEditData(mstGridID));

	Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
        Common.ajax(
                "POST",
                "/logistics/sro/saveSroItemMgmt.do",
                isExcelUploadFlag  ? param : GridCommon.getEditData(mstGridID),
                function(data, textStatus, jqXHR){ // Success
                    Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>");
                    //fn_search();

                    isExcelUploadFlag =false;
                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    Common.alert("Fail : " + jqXHR.responseJSON.message);

                    isExcelUploadFlag =false;
                }
        )
    });

}

//btn clickevent
$(function(){

	   $('#search').click(function() {
	        if(fn_validation()) {
	        	fn_getDataListAjax();
	        }
	    });

	   $('#clear').click(function() {
		   window.location.reload();
       });

	   $('#export').click(function() {
		   fn_gridExport("xlsx");
       });

       $('#save').click(function() {
    	   fn_save();
       });


       $('#upload').click(function() {
           $('#fileSelector').click();
       });


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



     $('#fileSelector').on('change', function(evt) {
         if (!checkHTML5Brower()) {
           //  alert("브라우저가 HTML5 를 지원하지 않습니다.\r\n서버로 업로드해서 해결하십시오.");

             isExcelUploadFlag =false;
             return;
         } else {

             isExcelUploadFlag =true;

             AUIGrid.destroy("#grid_wrap");

             var data = null;
             var file = evt.target.files[0];
             if (typeof file == "undefined") {
                // alert("파일 선택 시 오류 발생!!");
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


                 //console.log(workbook);
                 var jsonObj = process_wb(workbook);

                 createExcelAUIGrid( jsonObj[Object.keys(jsonObj)[0]] );
             };

             if(rABS) reader.readAsBinaryString(file);
             else reader.readAsArrayBuffer(file);

         }
     });

});



//엑셀 파일 시트에서 파싱한 JSON 데이터 기반으로 그리드 동적 생성
function createExcelAUIGrid(jsonData) {
if(AUIGrid.isCreated(mstGridID)) {
   AUIGrid.destroy(mstGridID);
   mstGridID = null;
}

   var columnExcelLayout = [];

   // 현재 엑셀 파일의 0번째 행을 기준으로 컬럼을 작성함.
   // 만약 상단에 문서 제목과 같이 있는 경우
   // 조정 필요.

   var firstRow = jsonData[0];

   if(typeof firstRow == "undefined") {
       alert("AUIGrid 로 변환할 수 없는 엑셀 파일입니다.");
       isExcelUploadFlag =false;
       return;
   }


  $.each(firstRow, function(n,v) {

	   var fil ;
	   if( $.trim(n)  =='No.')  'No.';
	   if( $.trim(n)  =='Location Code')      fil="loccd";
	   if( $.trim(n)  =='Location Name')     fil="locdesc";
	   if( $.trim(n)  =='Mat.Code')            fil="matcd";
	   if( $.trim(n)  =='Mat.Name')            fil="matname";
	   if($.trim(n)  =='Basic Qty')             fil="basicqty";
	   if( $.trim(n) =='ReOrderPoint')         fil="reoderpoint";
	  // if( $.trim(n) =='Additional')             fil="additional";
	  // if( $.trim(n) =='Location Level')       fil="loclevl";
	   if( $.trim(n) =='Use YN')                fil="useyn";




	   if  ($.trim(n)  !='No.'){

		   columnExcelLayout.push({
	           dataField :   fil ,
	           headerText : n,
	           width : 120
	       });

	   }
       console.log(columnExcelLayout);
   });

   // 그리드 생성
   mstGridID = AUIGrid.create("#grid_wrap", columnExcelLayout);



    var cvtJsonData  = JSON.stringify(jsonData).replace(/Location Code/g, 'loccd' );
          cvtJsonData  = cvtJsonData.replace(/Location Name/g, 'locdesc' );
          cvtJsonData  = cvtJsonData.replace(/Mat.Code/g, 'matcd' );
          cvtJsonData  = cvtJsonData.replace(/Mat.Name/g, 'matname' );
          cvtJsonData  = cvtJsonData.replace(/Basic Qty/g, 'basicqty' );
          cvtJsonData  = cvtJsonData.replace(/ReOrderPoint/g, 'reoderpoint' );
          //cvtJsonData  = cvtJsonData.replace(/Additional/g, 'additional' );
         // cvtJsonData  = cvtJsonData.replace(/Location Level/g, 'loclevl' );
          cvtJsonData  = cvtJsonData.replace(/Use YN/g, 'useyn' );

   // 그리드에 데이터 삽입
   AUIGrid.setGridData(mstGridID, JSON.parse(cvtJsonData));
   AUIGrid.hideColumnByDataField( mstGridID,"No.");
   AUIGrid.update(mstGridID);

}



//IE10, 11는 바이너리스트링 못읽기 때문에 ArrayBuffer 처리 하기 위함.
function fixdata(data) {
    var o = "", l = 0, w = 10240;
    for(; l<data.byteLength/w; ++l) o+=String.fromCharCode.apply(null,new Uint8Array(data.slice(l*w,l*w+w)));
    o+=String.fromCharCode.apply(null, new Uint8Array(data.slice(l*w)));
    return o;
}

//파싱된 시트의 CDATA 제거 후 반환.
function process_wb(wb) {
    var output = "";
    output = JSON.stringify(to_json(wb));
    output = output.replace( /<!\[CDATA\[(.*?)\]\]>/g, '$1' );
    return JSON.parse(output);
}

  //엑셀 시트를 파싱하여 반환
function to_json(workbook) {
    var result = {};
    workbook.SheetNames.forEach(function(sheetName) {
        var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName],{defval:""});
        if(roa.length >= 0){
            result[sheetName] = roa;
        }
    });

    return result;
}




</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Replenishment</li>
    <li>Auto Replenishment Master</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Auto Replenishment Master</h2>
</aside><!-- title_line end -->


<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
</c:if>
      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                 <tr>
                   <th scope="row">Location Type</th>
                   <td>
                     <select class="w100p" id="loctype" name="loctype"  ></select>
                   </td>
                   <th scope="row">Location Grade</th>
                   <td>
                        <select class="w100p" id="locgrad" name="locgrad" onchange="fn_changeLocation()"></select>
                   </td>
                   <th scope="row">Location</th>
                   <td>
                     <select class="w100p" id="tlocation" name="tlocation"></select>
                   </td>
                </tr>
                        </tbody>
        </table><!-- table end -->
    </section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Item Info</h3>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:180px" />
	    <col style="width:*" />
	    <col style="width:180px" />
	    <col style="width:*" />
	    <col style="width:100px" />
	</colgroup>
	<tbody>
	<tr>
	    <th scope="row">Type</th>
	    <td colspan="3">
	    <select class="w100p" id="cType" name="cType"></select>
	    </td>
	    <th scope="row">Category</th>
	    <td colspan="3">
	    <select class="w100p" id="catetype" name="catetype"></select>
	    </td>
	</tr>
	<tr>
       <th scope="row">Material Code</th>
	    <td colspan="3">
	    <input type="text" class="w100p" id="materialCode" name="materialCode" />
	    </td>

	    <th scope="row">Use YN</th>
	    <td colspan="3">
	         <input type="checkbox"  id="materialUseYn" name="materialUseYn" />
        </td>

	</tr>

	</tbody>
	</table><!-- table end -->

        <!-- table end -->
    </section><!-- search_table end -->
  </form>

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <div id='filediv' style="display:none;"><input type="file" id="fileSelector" name="files" accept=".xlsx"></div>
        <ul class="right_btns">
<!--<c:if test="${PAGE_AUTH.funcChange == 'Y'}"> -->
           <!--  <li><p class="btn_grid"><a id="re">Recalculate</a></p></li> -->

<!-- </c:if> -->
            <li><p class="btn_grid"><a id="export">ExcelDownload</a></p></li>
           <li><p class="btn_grid"><a id="upload">ExcelUpload</a></p></li>
        </ul>

         <div id="grid_wrap" class="mt10" style="height:430px;"></div>


         <ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="save">Save</a></p></li>
    </ul>

 </section><!-- search_result end -->

</section>
