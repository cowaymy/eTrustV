<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-right-style {
    text-align:right;
}
.my-left-style {
    text-align:left;
}

/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script  type="text/javascript">

var cancellGrid;

$(document).ready(function(){
    creatGrid();
    
    $("#btnSearch").click(fn_selectListAjax);
    $("#btnClear").click(fn_Clear);
    $("#btnNew").click(fn_newPop);
    
    CommonCombo.make("branch", "/sales/membership/selectBranchList", "", "", {
        id: "brnchId",
        name: "brnchName"
    });
    
    CommonCombo.make("reason", "/sales/membership/selectReasonList", "", "", {
        id: "resnId",
        name: "resnName"
    });

});

function fn_Clear(){
    $("#listSForm")[0].reset();

    AUIGrid.clearGridData(cancellGrid);   
}


//리스트 조회.
function fn_selectListAjax() {  
	   
    if($("#stTrmnatCrtDt").val() !=""){
        if($("#edTrmnatCrtDt").val()==""){
             var msg = '<spring:message code="sales.reqDate" />';
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
                    $("#edTrmnatCrtDt").focus();
                });
                return;
        }else{
        	
            var st = $("#stTrmnatCrtDt").val().replace(/\//g,'');
            var ed = $("#edTrmnatCrtDt").val().replace(/\//g,'');
            
            var stDate = st.substring(4,8) +""+ st.substring(2,4) +""+ st.substring(0,2);
            var edDate = ed.substring(4,8) +""+ ed.substring(2,4) +""+ ed.substring(0,2);
                            
            if(stDate > edDate ){        	
                 Common.alert("<spring:message code='commission.alert.dateGreaterCheck'/>", function(){
                     $("#edTrmnatCrtDt").focus();
                 });
                 return;
            }           
        }
    }
	
	Common.ajax("GET", "/sales/membership/selectCancellationList", $("#listSForm").serialize(), function(result) {
	    
	     console.log("성공.");
	     console.log( result);
	     
	    AUIGrid.setGridData(cancellGrid, result);
	
	});
}


function creatGrid(){
    
    var cancellColLayout = [ {
        dataField : "trmnatId",
        headerText : '',
        visible : false
    },{
        dataField : "trmnatRefNo",
        headerText : '<spring:message code="sales.cancellNo" />',
        width : 120
    },{
        dataField : "srvCntrctRefNo",
        headerText : '<spring:message code="sales.MembershipNo" />',
        width : 120   
    },{
        dataField : "salesOrdNo",
        headerText : '<spring:message code="sales.OrderNo" />',
        width : 100
    },{
        dataField : "resnDesc",
        headerText : '<spring:message code="sales.reasonDesc" />',
        style : "my-left-style",
        width : 180
    },{
        dataField : "trmnatPnalty",
        headerText : '<spring:message code="sales.penaltyCharges" />',
        dataType : "numeric",
        formatString : "#,##0.00",
        style : "my-right-style",
        width : 110
    }, {
        dataField : "taxInvcRefNo",
        headerText : '<spring:message code="sales.invoiceNo" />',
        width : 120
    }, {
        dataField : "userName",
        headerText : '<spring:message code="sales.Creator" />',
        width : 120
    }, {
        dataField : "trmnatCrtDt",
        headerText : '<spring:message code="sales.reqDate" />',
        width : 110
    }];
    

    var cancellOptions = {
               showStateColumn:false,
               showRowNumColumn    : false,
               usePaging : true,
               editable : false,
               headerHeight        : 30, 
               softRemoveRowMode:false
         }; 
    
    cancellGrid = GridCommon.createAUIGrid("#cancellGrid", cancellColLayout, "", cancellOptions); 
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(cancellGrid, "cellDoubleClick", function(event){

        $("#trmnatId").val(AUIGrid.getCellValue(cancellGrid , event.rowIndex , "trmnatId"));
        fn_viewPop();
    });
}

//view 화면 호출.
function fn_viewPop() {  	
	//var pram  ="?trmnatId="+ $("#trmnatId").val() ; 
    Common.popupDiv("/sales/membership/cancellationViewPop.do", {trmnatId :  $("#trmnatId").val()}, null, true, "_ViewSVMDetailsDiv1");
    
}


function fn_goCancellRAW(){
	Common.popupDiv("/sales/membership/membershipRentalCancellationRAWPop.do", null, null, true);
}

function fn_newPop(){
    Common.popupDiv("/sales/membership/cancellationNewPop.do", null, null, true, "cancellationNewPop");
    
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
<h2><spring:message code="sales.title.cancellation" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	<li><p class="btn_blue"><a href="#" id="btnSearch"><span class="search"></span><spring:message code="sales.Search" /></a></p></li>
	</c:if>
	<li><p class="btn_blue"><a href="#" id="btnClear"><span class="clear"></span><spring:message code="sales.Clear" /></a></p></li>
	<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	<li><p class="btn_blue"><a href="#" id="btnNew"><span></span><spring:message code="sales.btn.newRequest" /></a></p></li>
	</c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="listSForm" name="listSForm">
<input type = "hidden" id="trmnatId" name="trmnatId" >
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sales.refNo" /></th>
	<td><input type="text" id="trmnatRefNo" name="trmnatRefNo" title="" placeholder="" class="w100p" /></td>
	<th scope="row"><spring:message code="sales.reqDate" /></th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" id="stTrmnatCrtDt" name="stTrmnatCrtDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span><spring:message code="sales.To" /></span>
	<p><input type="text" id="edTrmnatCrtDt" name="edTrmnatCrtDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row"><spring:message code="sales.createUser" /></th>
	<td><input type="text" id="userName" name="userName" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.MembershipNo" /></th>
	<td><input type="text" id="srvCntrctRefNo" name="srvCntrctRefNo" title="" placeholder="" class="w100p" /></td>
	<th scope="row"><spring:message code="sales.OrderNo" /></th>
	<td><input type="text" id="salesOrdNo" name="salesOrdNo" title="" placeholder="" class="w100p" /></td>
	<th scope="row"><spring:message code="sales.keyInBranch" /></th>
	<td>
	<select class="w100p" id="branch" name="branch">
	</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.reason" /></th>
	<td colspan="3">
	<select class="w100p" id="reason" name="reason">
	</select>
	</td>
	<th scope="row"></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt><spring:message code="sales.Link" /></dt>
	<dd>	
	<ul class="btns">
		<li><p class="link_btn type2"><a href="#" onclick="javascript:fn_goCancellRAW();"><spring:message code="sales.raw" /></a></p></li>
	</ul>
	<p class="hide_btn"><a href="#" ><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="cancellGrid" style="width:100%; height:420px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->