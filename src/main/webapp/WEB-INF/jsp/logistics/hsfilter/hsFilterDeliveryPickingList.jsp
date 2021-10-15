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

var columnLayout = [

                    {dataField: "hsLoseLoclCode",headerText :"Cody Branch"          ,width:180   ,height:30 , visible:true, editable : false},
                    {dataField: "hsLoseItemCode",headerText :"Code"          ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "hsLoseItemDesc",headerText :"Desc"          ,width:240   ,height:30 , visible:true ,editable : false},
                    {dataField: "finalQty",headerText :"Deliver Q'ty"          ,width:120   ,height:30 , visible:true,editable : false ,formatString : "#,##0",dataType : "numeric"} ,
                    {dataField: "hsLoseItemUom",headerText :"UOM"          ,width:100   ,height:30 , visible:true,editable : false ,formatString : "#,##0",dataType : "numeric"},
                    {dataField: "box",headerText :"Box"          ,width:120   ,height:30 , visible:true,editable : false ,formatString : "#,##0",dataType : "numeric"},
                    {dataField: "loose",headerText :"Loose"          ,width:120   ,height:30 , visible:true,editable : false ,formatString : "#,##0",dataType : "numeric" },
                    {dataField: "refStoNo",headerText :"STO No"          ,width:120   ,height:30 , visible:true,editable : false ,formatString : "#,##0",dataType : "numeric" },
                    {dataField: "check",headerText :"Check"  ,width:80    ,height:30 , visible:true ,

                        renderer : {
                            type : "CheckBoxEditRenderer",
                            showLabel :false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                            checkValue : 1, // true, false 인 경우가 기본
                            unCheckValue : 0,
                            // 체크박스 disabled 함수
                            disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                            	if(item.refStoNo != "" && item.refStoNo != undefined )     return true; // true 반환하면 disabled 시킴

                                return false;
                            }
                        }
                    },


           ];




createAUIGrid =function(columnLayout ){

    var auiGridProps = {

            selectionMode : "multipleCells",

            showRowNumColumn : true,

            showRowCheckColumn : false,

            showStateColumn : true,

            enableColumnResize : true,

            enableMovingColumn : true
        };

    // 실제로 #grid_wrap 에 그리드 생성
    mstGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);
}


   $(document).ready(function() {
   	   doGetComboData('/logistics/totalstock/selectCDCList.do', '', '','searchCDC', 'S' , '');
   	   createAUIGrid(columnLayout);
   });





    function fn_changeCDC(){
        doGetComboData('/logistics/HsFilterDelivery/selectHSFilterDeliveryBranchList.do', {searchBranch: $("#searchCDC").val()}, '', 'searchBranchCb', 'S','');
    }



    // 리스트 조회.
   fn_getDataListAjax  = function () {


    	if($("#forecastMonth").val() ==""){
            Common.alert(" ForecastMonth  is required.");
    		return ;
    	}


        console.log($("#searchBranchCb").val());
       if($("#searchBranchCb").val() =="" || $("#searchBranchCb").val() ==null || $("#searchBranchCb").val() == undefined ){
               Common.alert(" searchBranchCb  is required.");
               return ;
       }

         Common.ajax("GET", "/logistics/HsFilterDelivery/selectHSFilterDeliveryPickingList.do", $("#hsFilterForm").serialize(), function(result) {
            console.log("성공.");
            //console.log( result);
           // console.log(result);
            AUIGrid.setGridData(mstGridID, result);
        });
    }


   function fn_gridExport(type){

       // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
       GridCommon.exportTo("grid_wrap", type, "Hs Filter Delivery_"+$("#forecastMonth").val());
   }




   function fn_pstreportGenerate(){

	     var option = {
                 isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
               };
	       Common.report("hsFilterForm", option);
  }




   function fn_openReport() {

	   var yyyy ;
	   var mm ;


	   $("#v_cdc_code").val($("#searchCDC").val() ) ;
	   $("#v_rdc_code").val($("#searchBranchCb").val()  )  ;

       const myArr = $("#forecastMonth").val().split("/");

	   $("#v_mm").val(myArr[0]);
	   $("#v_yyyy").val(myArr[1]) ;

	   var option = {
               isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
             };
         Common.report("hsFilterForm", option);

         AUIGrid.setRendererProp( mstGridID, 9, { "editable": true } );
   }



   function fn_doSave(){
       var rowCount = AUIGrid.getRowCount(mstGridID);
       if (rowCount ==  0){
    	    //Common.alert("Please Check Deliver Q'ty ");
           return false;
       }

       Common.confirm("Do you want to generate STO?",function (){

    	   for (var i = 0 ; i < rowCount ; i++){

               var refStoNo =AUIGrid.getCellValue(mstGridID , i , 'refStoNo');
               console.log(refStoNo);
               if( "" != refStoNo   &&   undefined != refStoNo){
                   Common.alert("Please check it out, STO  already exists");
                   return false;
                }

               var check =AUIGrid.getCellValue(mstGridID , i , 'check');
               if(check != 1){
                   Common.alert("Please It can be generate STO after picking");
                   return ;
               }
           }

           for (var i = 0 ; i < rowCount ; i++){
                   var reqty =AUIGrid.getCellValue(mstGridID , i , 'finalQty');

                    if(""==reqty || null == reqty || 0>= reqty){
                       Common.alert("Please Check Deliver Q'ty");
                       return false;
                     }
            }

            var dat = GridCommon.getGridData(mstGridID);
                  dat.form = $("#hsFilterForm").serializeJSON();

            Common.ajax("POST", "/logistics/HsFilterDelivery/saveSTOAdd.do", dat, function(result) {
                      if (result.code == '99'){
                                        AUIGrid.clearGridData(mstGridID);
                                        Common.alert(result.message , fn_getDataListAjax);
                       }else{
                                           Common.alert(""+result.message+"</br> Created : "+result.data, fn_getDataListAjax);
                        }

                        },
                        function(jqXHR, textStatus, errorThrown) {
                                     Common.alert("Fail : " + jqXHR.responseJSON.message);
                        }
              );

       });
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
<h2>HS Filter Delivery Picking List</h2>

  <ul class="right_btns">

      <li><p class="btn_blue"><a id="search" onclick="javascript:fn_getDataListAjax();"  ><span class="search"   ></span>Search</a></p></li>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

  <form action="#" method="post" id="hsFilterForm">
	<input type="hidden" id="v_cdc_code" name="v_cdc_code"  />
	<input type="hidden" id="v_rdc_code" name="v_rdc_code" />
	<input type="hidden" id="v_mm" name="v_mm"  />
	<input type="hidden" id="v_yyyy" name="v_yyyy"  />

	 <input type="hidden" id="memberLevel" name="memberLevel" value="${memberLevel}">
	 <input type="hidden" id="userName" name="userName" value="${userName}">
	 <input type="hidden" id="userType" name="userType" value="${userType}">
	<!--reportFileName,  viewType 모든 레포트 필수값 -->
	<input type="hidden" id="reportFileName" name="reportFileName" value="/logistics/BsFilterForecastDelivery.rpt" />
	<input type="hidden" id="viewType" name="viewType"  value="PDF" />
	<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
   <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row">Forecast Month <span class="must">*</span></th>
    <td>
    <input type="text" title="기준년월" class="j_date2" id="forecastMonth" name="forecastMonth"/>
    </td>
</tr>
 <th scope="row">CDC <span class="must">*</span> </th>
            <td>
                 <select  id="searchCDC" name="searchCDC"  onchange="fn_changeCDC()"> </select>
            </td>
<tr>
    <th scope="row">Branch <span class="must">*</span></th>
    <td>
        <select  id="searchBranchCb" name="searchBranchCb"  ></select>
    </td>
  </tr>
 </tbody>
    </table>

</form>
</section><!-- search_table end -->

<!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
            <li><p class="btn_grid"><a id="download"  onclick="javascript:fn_doSave();" >To Generate STO </a></p></li>
            <li><p class="btn_grid"><a id="download"  onclick="javascript:fn_openReport();" >Generate PDF</a></p></li>
            <li><p class="btn_grid"><a id="exceldownload" onclick="javascript:fn_gridExport('xlsx');">Generate  EXCEL</a></p></li>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="grid_wrap" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section><!-- pop_body end -->
