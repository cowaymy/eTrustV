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

                    {dataField: "hsLoseItemTypeDesc",headerText :"Stock Type"          ,width:100   ,height:30 , visible:true,editable : false},
                    {dataField: "hsLoseItemCtgryDesc",headerText :"Stock Category"          ,width:80   ,height:30 , visible:true,editable : false},

                    {dataField: "hsLoseItemCode",headerText :"Code"          ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "hsLoseItemDesc",headerText :"Desc"          ,width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "hsLoseItemFcastQty",headerText :"Forecast Q'ty"          ,width:120   ,height:30 , visible:true,editable : false},
                    {dataField: "hsLoseItemReordQty",headerText :"Forecast Q'ty(120%)"          ,width:120   ,height:30 , visible:true,editable : false}

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

    	if($("#searchCDC").val() ==""){
            Common.alert("CDC  is required.");
            return ;
        }



         Common.ajax("GET", "/logistics/HsFilterNewForecast/selectHSFilterForecastList.do", $("#hsFilterForm").serialize(), function(result) {
            console.log("성공.");
            //console.log( result);
           // console.log(result);
            AUIGrid.setGridData(mstGridID, result);
        });
    }


   function fn_gridExport(type){

       // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
       GridCommon.exportTo("grid_wrap", "xlsx", "Hs Filter Forecast_"+$("#forecastMonth").val());
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
<h2>HS Filter Forecast</h2>

  <ul class="right_btns">

      <li><p class="btn_blue"><a id="search" onclick="javascript:fn_getDataListAjax();"  ><span class="search"   ></span>Search</a></p></li>
      <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

  <form action="#" method="post" id="hsFilterForm">


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
   <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row"> Forecast Month <span class="must">*</span></th>
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
