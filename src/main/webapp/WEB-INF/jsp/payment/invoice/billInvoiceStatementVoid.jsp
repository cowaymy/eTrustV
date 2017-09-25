<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">
var detailListGridId;

var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 상태 칼럼 사용
        showStateColumn : false,
};


$(document).ready(function(){
	
	
});


var detailListLayout = [ 
                       {
                           dataField : "accBillOrdNo",
                           headerText : "Order No",
                           editable : false
                       }, {
                           dataField : "accBillRefNo",
                           headerText : "Bill No",
                           editable : false,
                           width: 100,
                       }, {
                           dataField : "accBillSchdulPriod",
                           headerText : "Installment",
                           editable : false,
                           width: 100
                       }, {
                           dataField : "codeName",
                           headerText : "Bill Type",
                           editable : false,
                           width: 200
                       }, {
                           dataField : "codename1",
                           headerText : "Bill Mode",
                           editable : false
                       }, {
                           dataField : "accBillSchdulAmt",
                           headerText : "Inst Amount",
                           editable : false
                       }, {
                           dataField : "accBillAdjAmt",
                           headerText : "Adjsutment",
                           editable : false
                       }, {
                           dataField : "accBillNetAmt",
                           headerText : "Net Amount",
                           editable : false
                       }];

	
	function searchList(){
		
		var statementNo = $("#statementNo").val();
		
		if(statementNo.trim() == "" || statementNo.trim().length < 11 ){
			Common.alert("You must key in the Invoice/Statement No. first.");
		}else{
			
			Common.ajax("GET","/payment/selectInvoiceInfo.do", {"statementNo" : statementNo}, function(result){
	            
	            console.log(result);
	            if(result.data.invoiceInfo != null || result.data.invoiceInfo != undefined){
	            	$("#search").hide();
	                $("#reSelect").show();
	                $("#displayVisible").show();
	                
	                $("#statementNo").addClass('readonly');
	                $("#brNo").text(result.data.invoiceInfo.brNo);
	                $("#startDt").text(result.data.invoiceInfo.startDt);
	                $("#custName").text(result.data.invoiceInfo.custName);
	                $("#cntcPerson").text(result.data.invoiceInfo.cntcPerson);
	                $("#mailAddress").text(result.data.invoiceInfo.addr1);
	                $("#mailAddress2").text(result.data.invoiceInfo.addr2);
	                $("#mailAddress3").text(result.data.invoiceInfo.addr3);
	                $("#postCode").text(result.data.invoiceInfo.postCode);
	                $("#stateName").text(result.data.invoiceInfo.stateName);
	                
	                AUIGrid.destroy(detailListGridId);
	                detailListGridId = GridCommon.createAUIGrid("detailGrid_wrap", detailListLayout ,"",gridPros);
	                AUIGrid.setGridData(detailListGridId, result.data.invoiceDetailList);
	            }else{
	            	Common.alert("No Invoice/Statement record found for this order number.");
	            }
	        });
		}
	}
	
	function fn_reSelect(){
        $("#search").show();
        $("#displayVisible").hide();
        $("#reSelect").hide();
        $("#statementNo").val("");
        $("#statementNo").removeClass('readonly');
    }
	
	//btn clickevent
	$(function(){
		
		$("#btnSave").click(function(){
			
			var remark = $("#remark").val();
			if(remark.trim() == "" ){
	            Common.alert("Remark are empty.");
	        }else{
	        	Common.ajax("GET","/payment/saveInvoiceVoidResult.do", {"statementNo" : statementNo, "remark" : remark}, function(result){
	                
	                console.log(result);
	                
	            });
	        }
	        
	    });
		
	});
</script>
<body>
<form action="" id="invoiceForm" name="invoiceForm">
	<div id="wrap"><!-- wrap start -->
	<section id="content"><!-- content start -->
		<ul class="path">
		    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		    <li>Invoice/Statement</li>
            <li>Billing Void</li>
		</ul>
		<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Billing Void</h2>
		</aside><!-- title_line end -->
		<section class="search_table"><!-- search_table start -->
		<aside class="title_line"><!-- title_line start -->
            <h3>Invoice/Statement Search For Void</h3>
        </aside><!-- title_line end -->
		<table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
			    <col style="width:190px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
			<tr>
			    <th scope="row">Invoice/Statement No</th>
			    <td><input type="text" title="" placeholder="" class="" id="statementNo" name="statementNo" />
			         <p class="btn_sky"><a href="javascript:searchList();" id="search">Search</a></p>
			         <p class="btn_sky"><a href="javascript:fn_reSelect();" id="reSelect" style="display: none">Reselect</a></p>
			    </td>
			</tr>
			</tbody>
        </table><!-- table end -->
        <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
        <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
        <dl class="link_list">
            <dt>Link</dt>
            <dd>
            <!-- <ul class="btns">
                <li><p class="link_btn"><a href="#">menu1</a></p></li>
                <li><p class="link_btn"><a href="#">menu2</a></p></li>
                <li><p class="link_btn"><a href="#">menu3</a></p></li>
                <li><p class="link_btn"><a href="#">menu4</a></p></li>
                <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
                <li><p class="link_btn"><a href="#">menu6</a></p></li>
                <li><p class="link_btn"><a href="#">menu7</a></p></li>
                <li><p class="link_btn"><a href="#">menu8</a></p></li>
            </ul>
            <ul class="btns">
                <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
                <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
                <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
                <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
                <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
                <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
                <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
                <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
            </ul> -->
            <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
            </dd>
        </dl>
        </aside><!-- link_btns_wrap end -->
        <div style="display: none" id="displayVisible">
        <aside class="title_line"><!-- title_line start -->
		      <h3>Invoice/Statement Particular Information</h3>
		</aside><!-- title_line end -->
		<table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
			    <col style="width:140px" />
			    <col style="width:*" />
			    <col style="width:100px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
			<tr>
			    <th scope="row">Statement No</th>
			    <td><span id="brNo"></span></td>
			    <th scope="row">Date</th>
			    <td><span id="startDt"></span></td>
			</tr>
			<tr>
			    <th scope="row">Customer Name</th>
			    <td colspan="3"><span id="custName"></span></td>
			</tr>
			<tr>
			    <th scope="row">Contact Person</th>
			    <td colspan="3"><span id="cntcPerson"></span></td>
			</tr>
			<tr>
			    <th scope="row">Mailing Address</th>
			    <td colspan="3"><span id="mailAddress"></span></td>
			</tr>
			<tr>
			    <th scope="row"></th>
			    <td colspan="3"><span id="mailAddress2"></span></td>
			</tr>
			<tr>
			    <th scope="row"></th>
			    <td colspan="3"><span id="mailAddress3"></span></td>
			</tr>
			<tr>
			    <th scope="row">PostCode</th>
			    <td><span id="postCode"></span></td>
			    <th scope="row">State</th>
			    <td><span id="stateName"></span></td>
			</tr>
			</tbody>
		</table><!-- table end -->
		<article id="detailGrid_wrap" class="grid_wrap"><!-- grid_wrap start -->
		</article><!-- grid_wrap end -->
		<section class="search_table"><!-- search_table start -->
		
		<aside class="title_line"><!-- title_line start -->
		<h3>Billing Void Information</h3>
		</aside><!-- title_line end -->
		
		<table class="type1"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:190px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		<tr>
		    <th scope="row">Remark</th>
		    <td><textarea cols="20" rows="5" id="remark"></textarea></td>
		</tr>
		</tbody>
		</table><!-- table end -->
		
		</section><!-- search_table end -->
		<ul class="center_btns">
		    <li><p class="btn_blue2"><a href="#" id="btnSave">Save</a></p></li>
		</ul>
	</div>
	</section><!-- content end -->
	<hr />
	</section>
	</div><!-- wrap end -->
</form>
</body>