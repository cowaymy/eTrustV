<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">


$(document).ready(function(){
	fn_initGstCondition();
	
    $('input[name=gstType]').change(function(){
    	fn_makeStatementList($(this).val());
    });
});

function fn_initGstCondition(){
	$('#gstType2').prop("checked", true);
	fn_makeStatementList(2);
}

function fn_makeStatementList(type){
	//alert(type);
	if(type == 1 ){
		$("#statementList option").remove();
		$("#statementList").append("<option value='initCompanyStatementPop.do'>CompanyStatement</option>");
		$("#statementList").append("<option value='initCompanyInvoicePop.do'>CompanyInvoice</option>");
		$("#statementList").append("<option value='initIndividualRentalStatementPop.do'>IndivisualStatement</option>");
		$("#statementList").append("<option value='initProformaInvoicePop.do'>ProformaInvoice</option>");
		$("#statementList").append("<option value='initOutrightInvoicePop.do'>OutrightInvoice</option>");
		$("#statementList").append("<option value='initPenaltyInvoicePop.do'>PenaltyInvoice</option>");
		$("#statementList").append("<option value='initMembershipInvoicePop.do'>MembershipInvoice</option>");
	}else if(type==2){
		$("#statementList option").remove();
		$("#statementList").append("<option value='initTaxInvoiceRentalPop.do'>TaxInvoice(Rental)</option>");
		$("#statementList").append("<option value='initTaxInvoiceOutrightPop.do'>TaxInvoice(Outright)</option>");
		$("#statementList").append("<option value='initTaxInvoiceMembershipPop.do'>TaxInvoice(Membership)</option>");
		$("#statementList").append("<option value='initTaxInvoiceRenMembershipPop.do'>TaxInvoice(Rental Membership)</option>");
		$("#statementList").append("<option value='initTaxInvoiceMiscellaneousPop.do'>TaxInvoice(Miscellaneous)</option>");
		$("#statementList").append("<option value='initStatementCompanyRentalPop.do'>Statement Company(Rental)</option>");
	}
}

function fn_goSelectedPage() {        
	var url = "/payment/" + $('#statementList').val();
    Common.popupDiv(url, null, null, true,"");
	
}

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Group</li>
        <li>Invoice Generate</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Invoice Generate</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" onclick ="javascript:fn_goSelectedPage()"><spring:message code='pay.btn.go'/></a></p></li>            
        </ul>    
    </aside>
    <!-- title_line end -->


 <!-- search_table start -->
    <section class="search_table">
    <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:160px" />
                    <col style="width:*" />
                    <col style="width:160px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th>TexType</th>
                    <td>
				        <label><input type="radio" name="gstType" id="gstType1" value="1" /><span>Before GST</span></label>
				        <label><input type="radio" name="gstType" id="gstType2" value="2" /><span>After GST</span></label>
                    </td>
                    <th>Invoice/Statement</th>
                    <td>
                        <select id="statementList" name="statementList" class="w100p">
                        </select>
                    </td>
                </tr>
                </tbody>
        </table>
    </section>	
</section>

