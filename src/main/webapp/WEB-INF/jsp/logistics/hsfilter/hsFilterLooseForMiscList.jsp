<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">



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
var mstGridID2;
var isExcelUploadFlag =false;


var keyValueList = [{"code":"", "value":"Choose One"} ,{"code":"Y", "value":"Y"}, {"code":"N", "value":"N"}];

var columnLayout = [

                    {dataField: "hsLoseRcd",headerText :"RDC Code"      ,width:100   ,height:30 , visible:true,editable : true},
                    {dataField: "hsLoseRcdDesc",headerText :"RDC Name"      ,width:100   ,height:30 , visible:true,editable : false},
					{dataField: "hsLoseItemTypeDesc",headerText :"Stock Type"      ,width:200   ,height:30 , visible:true,editable : false},
                    {dataField: "hsLoseItemTypeId",headerText :"Stock Type ID"          ,width:100   ,height:30 , visible:false,editable : false},
                    {dataField: "hsLoseItemCtgryDesc",headerText :"Stock Category"          ,width:180   ,height:30 , visible:true,editable : false},
                    {dataField: "hsLoseItemCode",headerText :"Code"          ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "hsLoseItemDesc",headerText :"Desc"          ,width:200   ,height:30 , visible:true ,editable : false},
                    {dataField: "hsLoseItemUom",headerText :"Uom"          ,width:100   ,height:30 , visible:true,editable : true},
                    {dataField: "hsLoseItemOprYn",headerText :"LooseYn"  ,width:80    ,height:30 , visible:true ,
                        renderer : {
                            type : "DropDownListRenderer",
                            list : keyValueList, //key-value Object 로 구성된 리스트
                            keyField : "code", // key 에 해당되는 필드명
                            valueField : "value" // value 에 해당되는 필드명
                        }
                    },
                    {dataField: "hsLoseItemDeliverQty",headerText :"Deliver Q'ty"          ,width:180   ,height:30 , visible:true,editable : true},
                    {dataField: "updDt",headerText :"Last Change Date"          ,width:120   ,height:30 , visible:true,editable : false, dataType : "date", formatString : "dd-mm-yyyy"}
           ];


createAUIGrid =function(columnLayout ){

    var auiGridProps = {

            selectionMode : "multipleCells",

            showRowNumColumn : true,

            showRowCheckColumn : false,

            showStateColumn : true,

            enableColumnResize : true,

            enableMovingColumn : true,

            editable : true

        };

    // 실제로 #grid_wrap 에 그리드 생성
    mstGridID = AUIGrid.create("#main_grid_wrap", columnLayout, auiGridProps);

    //mstGridID2 = AUIGrid.create("#sub_grid_wrap", columnLayout2, auiGridProps);

}


   $(document).ready(function() {

       doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //청구처 리스트 조회
       doGetCombo('/common/selectCodeList.do', '15', '','cmbType', 'M' , 'f_multiCombo'); //청구처 리스트 조회

       doGetComboData('/logistics/HsFilterLoose/selectMiscBranchList.do', '', '','cdbType', 'M' , 'f_multiCombo');


   	   createAUIGrid(columnLayout);


   });





    function fn_changeCDC(){
        doGetComboData('/logistics/HsFilterDelivery/selectHSFilterDeliveryBranchList.do', {searchBranch: $("#searchCDC").val()}, '', 'searchBranchCb', 'S','');
    }



    // 리스트 조회.
   fn_getDataListAjax  = function () {

         Common.ajax("GET", "/logistics/HsFilterLoose/selectHSFilterLooseForMiscList.do", $("#hsFilterForm").serialize(), function(result) {
            console.log("성공.");
            //console.log( result);
           console.log(result);
            AUIGrid.setGridData(mstGridID, result);
        });
    }



   fn_save =function (){

       var checkList = GridCommon.getGridData(mstGridID);

       console.log(checkList);
/*
           for(var i = 0 ; i < checkList.all.length ; i++){
               var itemStatus  = checkList.all[i].hsLoseItemUom;

               if(checkList.all[i].hsLoseItemUom == "" ||checkList.all[i].hsLoseItemUom ==null ){
                   Common.alert('* List status has "" Result  item(s). ');
                   return ;
               }
           }

*/
		var param  =  {};
		param.add = AUIGrid.exportToObject("#main_grid_wrap");

		console.log(GridCommon.getEditData(mstGridID));


	     // var prams ={data:GridCommon.getEditData(mstGridID)};

            Common.ajax("POST", "/logistics/HsFilterLoose/insertHSFilterLooseForMiscList.do",
            		   isExcelUploadFlag  ? param : GridCommon.getEditData(mstGridID),
            function(result) {
               Common.alert("<spring:message code='sys.msg.success' htmlEscape='false'/>");
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
               Common.alert("Fail : " + jqXHR.responseJSON.message);
               fn_getDataListAjax();
           });


   }



   function fn_gridExport(type){

       // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
       GridCommon.exportTo("main_grid_wrap", "xlsx", "Hs Filter Loose List");
   }


   function f_multiCombo() {
       $(function() {
           $('#cmbCategory').change(function() {

           }).multipleSelect({
               selectAll : true, // 전체선택
               width : '80%'
           });
           $('#cmbType').change(function() {

           }).multipleSelect({
               selectAll : true,
               width : '80%'
           });

           $('#cdbType').change(function() {

           }).multipleSelect({
               selectAll : true,
               width : '80%'
           });

       });
   }

   //btn clickevent
   $(function(){
	   $('#mainBt_upload').click(function() {
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

             AUIGrid.destroy("#main_grid_wrap");

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
        if( $.trim(n)  =='RDC')                  fil="hsLoseRcdCode";
        if( $.trim(n)  =='Code')                fil="hsLoseItemCode";
        if( $.trim(n)  =='Uom')                 fil="hsLoseItemUom";
        if( $.trim(n)  =='LooseYn')            fil="hsLoseItemOprYn";
        if( $.trim(n)  =='Deliver Qty')        fil="hsLoseItemDeliverQty";


        if  ($.trim(n)  !='No.'){

            columnExcelLayout.push({
                dataField :   fil ,
                headerText : n,
                width : 120
            });

        }
        console.log("==>"+columnExcelLayout);
    });

    // 그리드 생성
    mstGridID = AUIGrid.create("#main_grid_wrap", columnLayout);



     var cvtJsonData  = JSON.stringify(jsonData).replace(/RDC/g, 'hsLoseRcd' );
           cvtJsonData  = cvtJsonData.replace(/Code/g, 'hsLoseItemCode' );
           cvtJsonData  = cvtJsonData.replace(/Uom/g, 'hsLoseItemUom' );
           cvtJsonData  = cvtJsonData.replace(/LooseYn/g, 'hsLoseItemOprYn' );
           cvtJsonData  = cvtJsonData.replace(/Deliver Qty/g, 'hsLoseItemDeliverQty' );


          //console.log(jsonData)

                    console.log(JSON.parse(cvtJsonData))
    // 그리드에 데이터 삽입
    AUIGrid.setGridData(mstGridID, JSON.parse(cvtJsonData));
    // AUIGrid.setGridData(mstGridID, JSON.parse(jsonData));
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
    <li>HS Filter</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>HS Filter Loose Operation( Misc + Spare Parts)</h2>

  <ul class="right_btns">
      <li><p class="btn_blue"><a id="search" onclick="javascript:fn_save();"  ><span class="save"   ></span>Save</a></p></li>

      <li><p class="btn_blue"><a id="search" onclick="javascript:fn_getDataListAjax();"  ><span class="search"   ></span>Search</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

  <form action="#" method="post" id="hsFilterForm">


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
   <col style="width:170px" />
    <col style="width:*" />
       <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>

 <th scope="row">Stock Type</th>
            <td>
              <select class="w100p" id="cmbType" name="cmbType"></select>
            </td>
           <th scope="row">Stock Category</th>
   <td>
         <select class="w100p" id="cmbCategory" name="cmbCategory"></select>
    </td>

 <tr>
                    <th scope="row">Material Code</th>
                    <td>
                        <input type=text name="stkCd" id="stkCd" class="w100p" value=""/>
                    </td>
                    <th scope="row">Material Name</th>
                    <td>
                        <input type=text name="stkNm" id="stkNm" class="w100p" value=""/>
                    </td>
                </tr>
    <tr>
	          <th scope="row">CDB Branch</th>
	          <td>
                    <select class="w100p" id="cdbType" name="cdbType"></select>
	          </td>
	          <th scope="row"></th>
	          <td>
	          </td>
      </tr>

 </tbody>
    </table>

</form>
</section><!-- search_table end -->

<!-- data body start -->
    <section class="search_result"><!-- search_result start -->



        <div id='filediv' style="display:none;"><input type="file" id="fileSelector" name="files" accept=".xlsx"></div>


        <ul class="right_btns">
                <li><p class="btn_grid"><a id="mainBt_upload"  >Upload</a></p></li>
                <li><p class="btn_grid"><a id="mainBt_dw"onclick="javascript:fn_gridExport();" >Excel Dw</a></p></li>
         </ul>

         <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="main_grid_wrap" class="mt10" style="height:450px"></div>
         </article><!-- grid_wrap end -->


<!--
        <article class="tap_area">

         <ul class="right_btns">
                <li><p class="btn_grid"><a id="subBt_save" >Save</a></p></li>
                <li><p class="btn_grid"><a id="subBt_upload" >Upload</a></p></li>
                <li><p class="btn_grid"><a id="subBt_dw" >Excel Dw</a></p></li>
         </ul>
            <article class="grid_wrap">
                 <div id="sub_grid_wrap"  class="mt10" style="height:450px"></div>
            </article>
        </article>
 -->



    </section><!-- search_result end -->

</section><!-- pop_body end -->
