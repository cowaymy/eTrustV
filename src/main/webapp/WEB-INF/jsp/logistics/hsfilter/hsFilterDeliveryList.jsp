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
                    {dataField: "hsLoseYyyy",headerText :"Year"                                         ,width:  80   ,height:30 , visible:true, editable : false},
                    {dataField: "hsLoseMm",headerText :"Month"       ,width: 80    ,height:30 , visible:true, editable : false},
                    {dataField: "hsLoseLoclCode",headerText :"Location Code"          ,width:80   ,height:30 , visible:true, editable : false},
                    {dataField: "hsLoseLoclDesc",headerText :"Location Name"          ,width:150   ,height:30 , visible:true, editable : false},
                    {dataField: "hsLoseItemCode",headerText :"Code"          ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "hsLoseItemDesc",headerText :"Desc"          ,width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "hsLoseItemUom",headerText :"UOM"          ,width:100   ,height:30 , visible:true,editable : false},
                    {dataField: "hsLoseItemOprYn",headerText :"Loose Y/N"          ,width:80   ,height:30 , visible:true,editable : false},
                    {dataField: "hsLoseItemFcastQty",headerText :"Forecast"          ,width:120   ,height:30 , visible:true,editable : false ,formatString : "#,##0" ,dataType : "numeric" },
                    {dataField: "availableQty",headerText :"CDB Stock"          ,width:120   ,height:30 , visible:true,editable : false ,formatString : "#,##0" ,dataType : "numeric" },
                    {dataField: "finalQty",headerText :"Delivery"          ,width:120   ,height:30 , visible:true,editable : false ,formatString : "#,##0",dataType : "numeric" },
                    {dataField: "box",headerText :"Box"          ,width:120   ,height:30 , visible:true,editable : false ,formatString : "#,##0",dataType : "numeric" },
                    {dataField: "loose",headerText :"Loose"          ,width:120   ,height:30 , visible:true,editable : false ,formatString : "#,##0",dataType : "numeric" },
                    {dataField: "cdcAvailableQty",headerText :"CDC Stock"          ,width:120   ,height:30 , visible:true,editable : false ,formatString : "#,##0",dataType : "numeric" }

           ];




createAUIGrid =function(columnLayout ){




	var auiGridProps = {

	            editable : true,

	            // 그룹핑 패널 사용
	            useGroupingPanel : true,

	            // 필터 사용
	            enableFilter : true,

	            // 차례로 country, product, name 순으로 그룹핑을 합니다.
	            // 즉, 각 나라별, 각 제품을 구매한 사용자로 그룹핑
	            groupingFields : ["hsLoseItemCode"],

	            // 합계(소계) 설정
	            groupingSummary  : {
	                // 합계 필드는 price 1개에 대하여 실시 합니다.
	                dataFields : [ "finalQty"  ,"deliverQty"]
	            },

	            // 최초 보여질 때 모두 열린 상태로 출력 여부
	            displayTreeOpen : true,

	            // 그룹핑 후 셀 병합 실행
	            enableCellMerge : true,

	            // enableCellMerge 할 때 실제로 rowspan 적용 시킬지 여부
	            // 만약 false 설정하면 실제 병합은 하지 않고(rowspan 적용 시키지 않고) 최상단에 값만 출력 시킵니다.
	            cellMergeRowSpan : true,

	            // 브랜치에 해당되는 행을 출력 여부
	            showBranchOnGrouping : false,

	            blankNumericToNullOnEditing: false,

	            // 그리드 ROW 스타일 함수 정의
	            rowStyleFunction : function(rowIndex, item) {

	                if(item._$isGroupSumField) { // 그룹핑으로 만들어진 합계 필드인지 여부

	                    // 그룹핑을 더 많은 필드로 하여 depth 가 많아진 경우는 그에 맞게 스타일을 정의하십시오.
	                    // 현재 3개의 스타일이 기본으로 정의됨.(AUIGrid_style.css)
	                    switch(item._$depth) {  // 계층형의 depth 비교 연산
	                    case 2:
	                        return "aui-grid-row-depth1-style";
	                    case 3:
	                        return "aui-grid-row-depth2-style";
	                    case 4:
	                        return "aui-grid-row-depth3-style";
	                    default:
	                        return "aui-grid-row-depth-default-style";
	                    }
	                }

	                return null;
	            } // end of rowStyleFunction
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

         Common.ajax("GET", "/logistics/HsFilterDelivery/selectHSFilterDeliveryList.do", $("#hsFilterForm").serialize(), function(result) {
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





   function fn_openReport() {

	   // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
       GridCommon.exportTo("grid_wrap", "pdf", "Hs Filter Delivery_"+$("#forecastMonth").val());
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
<h2>HS Filter Delivery</h2>

  <ul class="right_btns">

      <li><p class="btn_blue"><a id="search" onclick="javascript:fn_getDataListAjax();"  ><span class="search"   ></span>Search</a></p></li>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

  <form action="#" method="post" id="hsFilterForm">
	<input type="hidden" id="V_FORECASTDATE" name="V_FORECASTDATE" />
	<input type="hidden" id="V_BRANCHID" name="V_BRANCHID" />
	<input type="hidden" id="V_CDCCODE" name="V_CDCCODE" />
	<input type="hidden" id="V_SAFETYLVL" name="V_SAFETYLVL"  value="20"/>

	 <input type="hidden" id="memberLevel" name="memberLevel" value="${memberLevel}">
	 <input type="hidden" id="userName" name="userName" value="${userName}">
	 <input type="hidden" id="userType" name="userType" value="${userType}">
	<!--reportFileName,  viewType 모든 레포트 필수값 -->
	<input type="hidden" id="reportFileName" name="reportFileName" />
	<input type="hidden" id="viewType" name="viewType" />
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
 <th scope="row">CDC</th>
            <td>
                 <select  id="searchCDC" name="searchCDC"  onchange="fn_changeCDC()"> </select>
            </td>
<tr>
    <th scope="row">Branch</th>
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
            <li><p class="btn_grid"><a id="exceldownload" onclick="javascript:fn_gridExport('xlsx');">Export for EXCEL</a></p></li>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="grid_wrap" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section><!-- pop_body end -->
