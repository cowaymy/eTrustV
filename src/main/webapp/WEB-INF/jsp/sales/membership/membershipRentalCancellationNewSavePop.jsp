<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">

$(document).ready(function(){	
	
	CommonCombo.make("newRequestor", "/common/selectCodeList.do", {groupCode:'52', orderValue:'CODE'}, "", {
	    id: "codeId",
	    name: "codeName"
	});
	
    CommonCombo.make("newReason", "/sales/membership/selectReasonList", "", "", {
        id: "resnId",
        name: "resnName"
    });
    
    
    if(!fn_ValidRequiredField_Select()){
    	fn_disableField();
        $("#btnConfirmDiv").hide();
    }
    
});


function fn_ValidRequiredField_Select()
{
    var valid = true;
    var message = "";
    var unbellAmt = "${memInfo.unbillAmt}";

    if ("${memInfo.cntrctRentalStus}" != "REG" && "${memInfo.cntrctRentalStus}" != "INV")
    {
        valid = false;
        message += "* <spring:message code="sales.msg.renStusChk" />";
    }
    if (parseFloat(unbellAmt) > 0)
    {
        valid = false;
        message += "* <spring:message code="sales.msg.unbillChk" />";
    }
    if (!valid)    	
    	Common.alert("<spring:message code="sales.alert.cancell.title" />" + DEFAULT_DELIMITER + message);

    return valid;
}

function fn_disableField(){

    $("#newRequestor").attr("disabled", true);
    $("#newRequestor").attr("class", "disabled");
    $("#newReason").attr("disabled", true);
    $("#newReason").attr("class", "disabled");
    $("#newRemark").attr("disabled", true);
    
}

function fn_ValidRequiredField_Save()
{
    var valid = true;
    var message = "";

    if ( $("#newRequestor").val() == "")
    {
        valid = false;
        message += "* <spring:message code="sales.msg.requestor" />";
    }
    if ($("#newReason").val() == "" )
    {
        valid = false;
        message += "* <spring:message code="sales.msg.reason" />";
    }
    if ($("#newRemark").val() == "")
    {
        valid = false;
        message += "* <spring:message code="sales.msg.remark" />";
    }
    if (!valid)
        Common.alert("<spring:message code="sales.alert.cancell.title" />" + DEFAULT_DELIMITER + message);

    return valid;
}

function fn_goLedgerPopOut(){
    var pram  ="?srvCntrctId="+${memInfo.srvCntrctId}+ "&srvCntrctOrdId="+${memInfo.srvCntrctOrdId}; 
    Common.popupDiv("/sales/membershipRental/mRLedgerPop.do"+pram ,null, null , true , '_LedgerDiv1');
}

function fn_saveContractCancellation(){
	
	if(fn_ValidRequiredField_Save()){
		
		if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){          
	          
            Common.ajax("POST", "/sales/membership/saveContractCancellation", $("#saveForm").serializeJSON(), function(result){

                console.log("성공." + JSON.stringify(result));
                console.log("data : " + result.data);

                fn_disableField();
                $("#btnConfirmDiv").hide();
                
                $("#_ViewSVMDetailsDiv1").hide();
                fn_selectCancellReqInfoAjax();
                Common.alert("<spring:message code="sales.succ.title" />" + DEFAULT_DELIMITER + "<spring:message code="sales.succ.msg" /> " + result.data );
              
            }
            , function(jqXHR, textStatus, errorThrown){
                try {
                    console.log("Fail Status : " + jqXHR.status);
                    console.log("code : "        + jqXHR.responseJSON.code);
                    console.log("message : "     + jqXHR.responseJSON.message);
                    console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                    }
                catch (e)
                {
                  console.log(e);
                }
                alert("Fail : " + jqXHR.responseJSON.message);

                Common.alert("<spring:message code="sales.fail.title" />" + DEFAULT_DELIMITER + "<spring:message code="sales.fail.msg" />");
            });

        }));
    }
	
}

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sales.title.cancellRep" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post" id="saveForm" name="saveForm">
	<input type="hidden" id="hSrvContractID" name="hSrvContractID" value= "${memInfo.srvCntrctId}">
	<input type="hidden" id="hOrderID" name="hOrderID" value= "${memInfo.srvCntrctOrdId}">
	<input type="hidden" id="hPackageID" name="hPackageID"  value= "${memInfo.srvCntrctPckgId}">
	<input type="hidden" id="hStockID" name="hStockID" value="${ordInfo.stockId }">
	<input type="hidden" id="newRentalAmt" name="newRentalAmt" value="${memInfo.srvCntrctRental}">
	
	<input type="hidden" id="newScheduleNo" name="newScheduleNo" value="${memInfo.scheduleNo}">
	<input type="hidden"  id="newObPeriod" name="newObPeriod" value="${memInfo.obPeriod}">
	<input type="hidden" id="newPenaltyCharge" name="newPenaltyCharge" value=" ${memInfo.penaltyCharge}">	

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
	<li><a href="#" class="on"><spring:message code="sales.tap.member" /></a></li>
	<li><a href="#"><spring:message code="sales.tap.orderInfo" /></a></li>
	<li><a href="#"><spring:message code="sales.tap.custInfo" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
<ul class="right_btns mb10" >
    <li><p class="btn_blue2" id ='viewLederLay'><a href="#" onclick="javascript:fn_goLedgerPopOut()" ><spring:message code="sales.btn.ledger" /></a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sales.MembershipNo" /></th>
	<td><span>${memInfo.srvCntrctRefNo}</span></td>
	<th scope="row"><spring:message code="sales.memType" /></th>
	<td><span>${memInfo.cnfmType}</span></td>
	<th scope="row"><spring:message code="sales.keyInDate" /></th>
	<td><span>${memInfo.srvCntrctCrtDt}</span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.memStus" /></th>
	<td><span>${memInfo.cntrctStusCode}</span></td>
	<th scope="row"><spring:message code="sales.RentalStatus" /></th>
	<td><span>${memInfo.cntrctRentalStus}</span></td>
	<th scope="row"><spring:message code="sales.poNum" /></th>
	<td><span>${memInfo.poRefNo}</span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.Package" /></th>
	<td colspan="3"><span>${memInfo.srvCntrctPacDesc}</span></td>
	<th scope="row"><spring:message code="sales.Duration" /></th>
	<td><span>${memInfo.qotatCntrctDur} <spring:message code="sales.month" /></span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.lastMem" /></th>
	<td colspan="3"><span>${memInfo.srvCntrctPacDesc}</span></td>
	<th scope="row"><spring:message code="sales.ExpireDate" /></th>
	<td><span>${memInfo.srvPrdExprDt}</span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.memFee" /></th>
	<td><span>${memInfo.srvCntrctRental}</span></td>
	<th scope="row"><spring:message code="sales.outAmt" /></th>
	<td><span>${memInfo.outstandingAmount}</span></td>
	<th scope="row"><spring:message code="sales.unbillAmt" /></th>
	<td><span>${memInfo.unbillAmt}</span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.pakPro" /></th>
	<td colspan="5"><span>${memInfo.pacPromoDesc}</span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.filterPro" /></th>
	<td colspan="3"><span>${memInfo.filPromoDesc}</span></td>
	<th scope="row"><spring:message code="sales.bsFre" /></th>
	<td><span>${memInfo.qotatCntrctFreq} <spring:message code="sales.month" /></span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sales.OrderNo" /></th>
	<td><span>${ordInfo.ordNo }</span></td>
	<th scope="row"><spring:message code="sales.ordDt" /></th>
	<td><span>${ordInfo.ordDt }</span></td>
	<th scope="row"><spring:message code="sales.ordStus" /></th>
	<td><span>${ordInfo.ordStusName }</span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.ProductCategory" /></th>
	<td colspan="3"><span>${ordInfo.stkCtgryName }</span></td>
	<th scope="row"><spring:message code="sales.poNum" /></th>
	<td><span>${ordInfo.ordPoNo }</span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.productCode" /></th>
	<td><span>${ordInfo.stockCode }</span></td>
	<th scope="row"><spring:message code="sales.pakName" /></th>
	<td colspan="3"><span>${ordInfo.stockDesc }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2 class="pt0"><spring:message code="sales.tap.custInfo" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sales.cusName" /></th>
	<td colspan="3"><span>${custInfo.custName }</span></td>
	<th scope="row"><spring:message code="sales.NRIC" /> / <spring:message code="sales.CompanyNo" /></th>
	<td><span>${custInfo.custNric }</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sales.insAddr" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row" rowspan="4"><spring:message code="sales.insAddr" /></th>
	<td colspan="3"><span>${custInfo.instAddrDtl }</span></td>
	<th scope="row"><spring:message code="sales.Country" /></th>
	<td><span>${custInfo.instCountry }</span></td>
</tr>
<tr>
	<td colspan="3"><span>${custInfo.instStreet }</span></td>
	<th scope="row"><spring:message code="sales.State" /></th>
	<td><span>${custInfo.instCity }</span></td>
</tr>
<tr>
	<td colspan="3"><span></span></td>
	<th scope="row"><spring:message code="sales.Area" /></th>
	<td><span>${custInfo.instArea }</span></td>
</tr>
<tr>
	<th scope="row" colspan="2"></th>
    <th scope="row"><span class="bold_text"></span>
	<th scope="row"><spring:message code="sales.AreaPostcode" /></th>
	<td><span>${custInfo.instPostcode }</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sales.ContactPerson" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row" ><spring:message code="sales.ContactPersonName" /></th>
	<td colspan="5"><span>${custInfo.contName }</span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.MobileNo" /></th>
	<td><span>${custInfo.telM1 }</span></td>
	<th scope="row"><spring:message code="sales.OfficeNo" /></th>
	<td><span>${custInfo.telO }</span></td>
	<th scope="row"><spring:message code="sales.HouseNo" /></th>
	<td><span>${custInfo.telR }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sales.Outstanding" /> &amp; <spring:message code="sales.PenaltyInformation" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row" colspan="4"></th>
	<th scope="row"><span class="bold_text"><spring:message code="sales.totAmt_RM" /></span></th>
	<td class="blue_highlight"><span class="white_text bold_text">${memInfo.totalAmt}</span></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.TotalUsedMonth" /></th>
	<td><span>${memInfo.scheduleNo}</span></td>
	<th scope="row"><spring:message code="sales.ObligationPeriod" /></th>
	<td><span>${memInfo.obPeriod}</span></td>
	<th scope="row"><spring:message code="sales.PenaltyCharge" /></th>
	<td><span>${memInfo.penaltyCharge}</span></td> 
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sales.subTitle.ordCanReqInfo" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sales.Requestor" /><span class="must">*</span></th>
	<td><select id="newRequestor" name="newRequestor" class="" ></select></td>
	<th scope="row"><spring:message code="sales.Reason" /><span class="must">*</span></th>
	<td><select id="newReason" name="newReason" class=""></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.Remark" /><span class="must">*</span></th>
	<td colspan="3"><textarea class="w100p" id="newRemark" name="newRemark"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
<ul class="center_btns mt20">
<div id="btnConfirmDiv" >
	<li><p class="btn_blue2"><a href="#" onclick="javascript:fn_saveContractCancellation();"><spring:message code="sales.btn.CtoC" /></a></p></li>
</div>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->