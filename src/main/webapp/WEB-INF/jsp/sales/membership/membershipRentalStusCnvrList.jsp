<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

var stusGridID;

$(document).ready(function(){

	creatGrid();
     $("#btnSearch").click(fn_selectListAjax);
     $("#btnClear").click(fn_Clear);
     $("#btnNew").click(fn_newCnvr);
     
});


//리스트 조회.
function fn_selectListAjax() {
	
	if($("#stRsCnvrCrtDt").val() !=""){
        if($("#edRsCnvrCrtDt").val()==""){
             var msg = '<spring:message code="sales.CreateDate" />';
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
                    $("#edRsCnvrCrtDt").focus();
                });
                return;
        }else{
        	if($("#stRsCnvrCrtDt").val() >   $("#edRsCnvrCrtDt").val() ){
            	 Common.alert("<spring:message code='commission.alert.dateGreaterCheck'/>", function(){
                     $("#edRsCnvrCrtDt").focus();
                 });
                 return;
            }        	
        }
    }
	
	if($("#stRsCnvrCnfmDt").val() !=""){
        if($("#edRsCnvrCnfmDt").val()==""){
             var msg = '<spring:message code="sales.ConfirmDate" />';
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
                    $("#edRsCnvrCnfmDt").focus();
                });

                return;
        }else{
        	if($("#stRsCnvrCnfmDt").val() >   $("#edRsCnvrCnfmDt").val() ){
            	 Common.alert("<spring:message code='commission.alert.dateGreaterCheck'/>", function(){
                     $("#edRsCnvrCnfmDt").focus();
                 });
                 return;
            }        	
        }
    }
	
  Common.ajax("GET", "/sales/membership/selectCnvrList", $("#listSForm").serialize(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(stusGridID, result);

  });
}

function fn_Clear(){
	$("#listSForm")[0].reset();

    AUIGrid.clearGridData(stusGridID);   
	/* AUIGrid.destroy(stusGridID);
	creatGrid(); */
}

//NEW Conversion 화면 호출.
function fn_newCnvr() {  
	Common.popupDiv("/sales/membership/membershipRentalStusCnvrNewPop.do",null, fn_selectListAjax, true, "membershipRentalStusCnvrNewPop");
}

//Conversion view 화면 호출.
function fn_CnvrView() {  
	Common.popupDiv("/sales/membership/membershipRentalStusCnvrViewPop.do", null, fn_selectListAjax, true, "membershipRentalStusCnvrViewPop");
}

function creatGrid(){

    var stusColLayout = [ {
        dataField : "rsCnvrNo",
        headerText : '<spring:message code="sales.BatchNo" />',
        width : 110
    },{
        dataField : "batchStatus",
        headerText : '<spring:message code="sales.title.batchStatus" />',
        width : 75
    },{
        dataField : "rsCnvrStusFrom",
        headerText : '<spring:message code="sales.title.statusFrom" />',
        width : 75
    },{
        dataField : "rsCnvrStusTo",
        headerText : '<spring:message code="sales.title.statusTo" />',
        width : 75
    }, {
        dataField : "convertStatus",
        headerText : '<spring:message code="sales.title.convertStatus" />',
        width : 75
    },{
        dataField : "rsCnvrDt",
        headerText : '<spring:message code="sales.ConvertDate" />',
        width : 100
    },{
        dataField : "crtUserName",
        headerText : '<spring:message code="sales.Creator" />',
        width : 120
    },{
        dataField : "rsCnvrCrtDt",
        headerText : '<spring:message code="sales.CreateDate" />',
        width : 90
    },{
        dataField : "cnfmUserName",
        headerText : '<spring:message code="sales.ConfirmBy" />',
        width : 120
    },{
        dataField : "rsCnvrCnfmDt",
        headerText : '<spring:message code="sales.ConfirmDate" />',
        width : 120
    },{
        dataField : "rsCnvrId",
        headerText : '',
        width : 150,
        visible : false
    },{
        dataField : "rsStusId",
        headerText : '',
        width : 90,
        visible : false
    }];
    

    var stusOptions = {
               showStateColumn:false,
               showRowNumColumn    : true,
               usePaging : true, 
               headerHeight        : 30, 
               editable : false
         }; 
    
    stusGridID = GridCommon.createAUIGrid("#stusGridID", stusColLayout, "", stusOptions);
    
 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(stusGridID, "cellDoubleClick", function(event){
    	
    	 $("#sRsStusId").val(AUIGrid.getCellValue(stusGridID , event.rowIndex , "rsStusId"));
         $("#sRsCnvrId").val( AUIGrid.getCellValue(stusGridID , event.rowIndex , "rsCnvrId"));
    	
    	fn_CnvrView();
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sales.statusTitle" /></h2>
<ul class="right_btns">
	<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	<li><p class="btn_blue"><a href="#" id="btnSearch"><span class="search"></span><spring:message code="sales.Search" /></a></p></li>
	</c:if>
	<li><p class="btn_blue"><a href="#" id="btnClear"><span class="clear"></span><spring:message code="sales.Clear" /></a></p></li>
	<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	<li><p class="btn_blue"><a href="#" id="btnNew"><spring:message code="sales.new" /></a></p></li>
	</c:if>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="listSForm" name="listSForm">
<input type="hidden" id ="sRsCnvrId" name="sRsCnvrId">
<input type="hidden" id ="sRsStusId" name="sRsStusId">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sales.ConversionNo" /></th>
	<td colspan="3"><input type="text" title="" id="rsCnvrNo" name="rsCnvrNo" placeholder="<spring:message code="sales.ConversionNumber" />" class="w100p" /></td>
	<th scope="row"><spring:message code="sales.CreateDate" /></th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" id="stRsCnvrCrtDt" name="stRsCnvrCrtDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input type="text" id="edRsCnvrCrtDt" name="edRsCnvrCrtDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.BatchStatus" /></th>
	<td>
	<select class="multy_select w100p" multiple="multiple" id="rsStusId" name ="rsStusId">
		<option value="1"><spring:message code="sales.Active" /></option>
		<option value="4"><spring:message code="sales.Completed" /></option>
		<option value="8"><spring:message code="sales.Inactive" /></option>
	</select>
	</td>
	<th scope="row"><spring:message code="sales.ConvertStatus" /></th>
	<td>
	<select class="multy_select w100p" multiple="multiple" id="rsCnvrStusId" name ="rsCnvrStusId">
		<option value="44" selected="selected"><spring:message code="sales.Pending" /></option>
		<option value="4"><spring:message code="sales.Completed" /></option>
	</select>
	</td>
	<th scope="row"><spring:message code="sales.Creator" /></th>
	<td><input type="text" id="creatUser" name="creatUser" title="" placeholder="<spring:message code="sales.CreatorUsername" />" class="w100p" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.StatusFrom" /></th>
	<td>
	<select class="multy_select w100p" multiple="multiple" id="rsCnvrStusFrom" name ="rsCnvrStusFrom">
		<option value="REG"><spring:message code="sales.Regular" /></option>
		<option value="INV"><spring:message code="sales.Investigate" /></option>
		<option value="SUS"><spring:message code="sales.Suspend" /></option>
		<option value="RET"><spring:message code="sales.Return" /></option>
	</select>
	</td>
	<th scope="row"><spring:message code="sales.StatusTo" /></th>
	<td>
	<select class="multy_select w100p" multiple="multiple" id="rsCnvrStusTo" name="rsCnvrStusTo">
        <option value="REG"><spring:message code="sales.Regular" /></option>
        <option value="INV"><spring:message code="sales.Investigate" /></option>
        <option value="SUS"><spring:message code="sales.Suspend" /></option>
        <option value="RET"><spring:message code="sales.Return" /></option>
        <option value="TER"><spring:message code="sales.Terminate" /></option>
	</select>
	</td>
	<th scope="row"><spring:message code="sales.ConfirmAt" /></th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" id="stRsCnvrCnfmDt" name="stRsCnvrCnfmDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input type="text" id="edRsCnvrCnfmDt" name="edRsCnvrCnfmDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.Remark" /></th>
	<td colspan="3"><input type="text" id="rsCnvrRem" name="rsCnvrRem" title="" placeholder="<spring:message code="sales.Remark" />" class="w100p" /></td>
	<th scope="row"><spring:message code="sales.ConfirmBy" /></th>
	<td><input type="text" id="confirmUser" name="confirmUser" title="" placeholder="<spring:message code="sales.ConfirmByUsername" />" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<!-- <ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul> -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="stusGridID" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->