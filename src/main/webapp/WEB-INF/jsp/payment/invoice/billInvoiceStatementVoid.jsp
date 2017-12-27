<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
                           headerText : "<spring:message code='pay.head.orderNo'/>",
                           editable : false
                       }, {
                           dataField : "accBillRefNo",
                           headerText : "<spring:message code='pay.head.billNo'/>",
                           editable : false
                       }, {
                           dataField : "accBillSchdulPriod",
                           headerText : "<spring:message code='pay.head.installment'/>",
                           editable : false
                       }, {
                           dataField : "codeName",
                           headerText : "<spring:message code='pay.head.billType'/>",
                           editable : false
                       }, {
                           dataField : "codename1",
                           headerText : "<spring:message code='pay.head.billMode'/>",
                           editable : false
                       }, {
                           dataField : "accBillSchdulAmt",
                           headerText : "<spring:message code='pay.head.instAmount'/>",
                           editable : false
                       }, {
                           dataField : "accBillAdjAmt",
                           headerText : "<spring:message code='pay.head.adjsutment'/>",
                           editable : false
                       }, {
                           dataField : "accBillNetAmt",
                           headerText : "<spring:message code='pay.head.netAmount'/>",
                           editable : false
                       }];

	
	function searchList(){
		
		var statementNo = $("#statementNo").val();
		
		if(statementNo.trim() == "" || statementNo.trim().length < 11 ){
			Common.alert("<spring:message code='pay.alert.invoiceStateNo'/>");
		}else{
			
			Common.ajax("GET","/payment/selectInvoiceInfo.do", {"statementNo" : statementNo}, function(result){
	            
	            console.log(result);
	            if(result.data.invoiceInfo != null || result.data.invoiceInfo != undefined){
	            	$("#btnSearch").hide();
	                $("#btnReSelect").show();
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
	            	Common.alert("<spring:message code='pay.alert.orderNoNotFound'/>");
	            }
	        });
		}
	}
	
	function fn_reSelect(){
        $("#btnSearch").show();
        $("#displayVisible").hide();
        $("#btnReSelect").hide();
        $("#statementNo").val("");
        $("#statementNo").removeClass('readonly');
        
        $("#brNo").text('');
        $("#startDt").text('');
        $("#custName").text('');
        $("#cntcPerson").text('');
        $("#mailAddress").text('');
        $("#mailAddress2").text('');
        $("#mailAddress3").text('');
        $("#postCode").text('');
        $("#stateName").text('');
        $("#remark").val('');
    }
	
	//btn clickevent
	$(function(){
		
		$("#btnSave").click(function(){
			
			var remark = $("#remark").val();
			var statementNo = $("#statementNo").val();
			if(remark.trim() == "" ){
	            Common.alert("Remark are empty.");
	        }else{
	        	Common.ajax("GET","/payment/saveInvoiceVoidResult.do", {"statementNo" : statementNo, "remark" : remark}, function(result){
	                
	                fn_reSelect();
	                Common.alert("<spring:message code='pay.alert.saveInvoiceVoidResult' arguments='"+statementNo+"' htmlEscape='false'/>");
	                
	            }, function(jqXHR, textStatus, errorThrown) {
	            	Common.alert("<spring:message code='pay.alert.dataFailed'/>");
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
		            <li>Billing Void Mgmt</li>
				</ul>
				
				<aside class="title_line"><!-- title_line start -->
				<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
				<h2>Billing Void Mgmt</h2>
				</aside><!-- title_line end -->
				
				<section class="search_table"><!-- search_table start -->
				<aside class="title_line"><!-- title_line start -->
		            <h3>Invoice/Statement Search For Void</h3>
		        </aside><!-- title_line end -->
		        
		        <ul class="right_btns mb10">
                    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                    <li><p class="btn_blue"><a href="javascript:searchList();" id="btnSearch"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
                    </c:if>
                    <li><p class="btn_blue"><a href="javascript:fn_reSelect();" id="btnReSelect" style="display: none"><span class="search"></span><spring:message code='pay.btn.reselect'/></a></p></li>
                </ul>
		        
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
					         <!-- <p class="btn_blue"><a href="javascript:searchList();" id="btnSearch"><span class="search"></span>Search</a></p>
					         <p class="btn_blue"><a href="javascript:fn_reSelect();" id="btnReSelect" style="display: none"><span class="search"></span>Reselect</a></p>
					           -->
					    </td>
					</tr>
					</tbody>
		        </table><!-- table end -->
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
					    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
					    <li><p class="btn_blue2"><a href="#" id="btnSave"><spring:message code='sys.btn.save'/></a></p></li>
					    </c:if>
					  </ul>
			       </div>
			    </section><!-- content end -->
			    <hr />
			</section>
		</div><!-- wrap end -->
	 </form>
</body>