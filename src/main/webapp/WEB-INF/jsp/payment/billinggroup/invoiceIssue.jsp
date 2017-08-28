<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

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
		$("#statementList").append("<option value='initCompanyStatement.do'>CompanyStatement</option>");
		$("#statementList").append("<option value='initCompanyInvoice.do'>CompanyInvoice</option>");
		$("#statementList").append("<option value='initIndividualRentalStatement.do'>IndivisualStatement</option>");
		$("#statementList").append("<option value='initProformaInvoice.do'>ProformaInvoice</option>");
		$("#statementList").append("<option value='initOutrightInvoice.do'>OutrightInvoice</option>");
		$("#statementList").append("<option value='initPenaltyInvoice.do'>PenaltyInvoice</option>");
		$("#statementList").append("<option value='initMembershipInvoice.do'>MembershipInvoice</option>");
	}else if(type==2){
		$("#statementList option").remove();
		$("#statementList").append("<option value='initTaxInvoiceRental.do'>TaxInvoice(Rental)</option>");
		$("#statementList").append("<option value='initTaxInvoiceOutright.do'>TaxInvoice(Outright)</option>");
		$("#statementList").append("<option value='initTaxInvoiceMembership.do'>TaxInvoice(Membership)</option>");
		$("#statementList").append("<option value='initTaxInvoiceRenMembership.do'>TaxInvoice(Rental Membership)</option>");
		$("#statementList").append("<option value='initTaxInvoiceMiscellaneous.do'>TaxInvoice(Miscellaneous)</option>");
		$("#statementList").append("<option value='initStatementCompanyRental.do'>Statement Company(Rental)</option>");
	}
}

function fn_goSelectedPage() {        
	
	location.href='/payment/' + $("#statementList").val();
}


</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Group</li>
        <li>InvoiceIssue</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Invoice Issue</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_goSelectedPage();"><span class="search"></span>go</a></p></li>
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

	<!-- search_result start -->
	<section class="search_result">     
	    <!-- link_btns_wrap start -->
	    <aside class="link_btns_wrap">
	        <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
	        <dl class="link_list">
	            <dt>Link</dt>
	            <dd>                    
	                <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	            </dd>
	        </dl>
	    </aside>
	    <!-- link_btns_wrap end -->
        
    </section>
</section>

