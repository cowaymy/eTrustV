<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

	$(document).ready(function(){
	    
	    //Call Ajax
//	    fn_getDealerListAjax();
	  
    doGetCombo('/sales/pst/getInchargeList', '', '','cmbPstIncharge', 'S' , ''); //Incharge Person

	});

	function fn_dealerInfo(){

		insertForm.dealerId.value = insertForm.cmbDealer.value;
		
	    Common.ajax("GET", "/sales/pst/dealerInfo.do", $("#insertForm").serializeJSON(), function(result) {
	    	$("#dealerEmail").val(result.dealerEmail);
	    	$("#dealerNric").val(result.dealerNric);
	    	$("#dealerBrnchId").val(result.dealerBrnchId);
	    	$("#brnchId").val(result.brnchId);
	    	
	    	$("#newMailaddrDtl").val(result.addrDtl);
	    	$("#newMailstreet").val(result.street);
	    	$("#newMailarea").val(result.area);
	    	$("#newMailcity").val(result.city);
	    	$("#newMailpostcode").val(result.postcode);
            $("#newMailstate").val(result.state);
            $("#newMailcountry").val(result.country);
            
            $("#newDelvryaddrDtl").val(result.addrDtl);
            $("#newDelvrystreet").val(result.street);
            $("#newDelvryarea").val(result.area);
            $("#newDelvrycity").val(result.city);
            $("#newDelvrypostcode").val(result.postcode);
            $("#newDelvrystate").val(result.state);
            $("#newDelvrycountry").val(result.country);
            
            $("#newMailContCntName").val(result.cntName);
            $("#newMailContDealerIniCd").val(result.dealerIniCd);
            $("#newMailContGender").val(result.gender);
            $("#newMailContNric").val(result.nric);
            $("#newMailContRaceName").val(result.raceName);
            $("#newMailContTelF").val(result.telf);
            $("#newMailContTelM1").val(result.telM1);
            $("#newMailContTelR").val(result.telR);
            $("#newMailContTelO").val(result.telO);
            
            $("#newDelvryContCntName").val(result.cntName);
            $("#newDelvryContDealerIniCd").val(result.dealerIniCd);
            $("#newDelvryContGender").val(result.gender);
            $("#newDelvryContNric").val(result.nric);
            $("#newDelvryContRaceName").val(result.raceName);
            $("#newDelvryContTelF").val(result.telf);
            $("#newDelvryContTelM1").val(result.telM1);
            $("#newDelvryContTelR").val(result.telR);
            $("#newDelvryContTelO").val(result.telO);
	    	
	    	doGetCombo('/sales/pst/pstNewCmbDealerBrnchList', result.dealerBrnchId, result.brnchId,'cmbPstBranch', 'S' , ''); //Incharge Person
	    	
            console.log("data : " + result);
            
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
          }
          catch (e) {
              console.log(e);
              Common.alert("Liar data search failed.");
          }

          alert("Fail : " + jqXHR.responseJSON.message);          
      });
	}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New PST Request</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num3">
    <li><a href="#" class="on">Particular Information</a></li>
    <li><a href="#">Mailing Address</a></li>
    <li><a href="#">Delivery Address</a></li>
    <li><a href="#">Delivery Contact Person</a></li>
    <li><a href="#">Mailing Contact Person</a></li>
    <li><a href="#">Delivery Stock</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form id="insertForm" name="insertForm" method="post">
    <input type="hidden" id="dealerId" name="dealerId">
    <input type="hidden" id="dealerBrnchId" name="dealerBrnchId">
    <input type="hidden" id="brnchId" name="brnchId">
    
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
    <th scope="row">Dealer<span class="must">*</span></th>
    <td>
	    <select class="w100p" id="cmbDealer" name="cmbDealer" onchange="fn_dealerInfo()">
	       <option value="">Dealer</option>
           <c:forEach var="list" items="${cmbDealerList }">
               <option value="${list.dealerId}">${list.dealerName}</option>
           </c:forEach>
	    </select>
    </td>
    <th scope="row">Email</th>
    <td><input type="text" id="dealerEmail" name="dealerEmail" title="" placeholder="Email Address" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
	    <select class="w100p" id="cmbPstBranch" name="cmbPstBranch" disabled="disabled">
	    </select>
    </td>
    <th scope="row">NRIC/Company No</th>
    <td><input type="text" id="dealerNric" name="dealerNric" title="" placeholder="NRIC/Company Number" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Person In Charge<span class="must">*</span></th>
    <td>
	    <select class="w100p" id="cmbPstIncharge" name="cmbPstIncharge">
	    </select>
    </td>
    <th scope="row">Customer PO</th>
    <td><input type="text" id="pstNewCustPo" name="pstNewCustPo" title="" placeholder="Customer PO" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea cols="20" rows="5" id="pstNewRem" name="pstNewRem"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

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
    <th scope="row" rowspan="2">Mailing Address<span class="must">*</span></th>
    <td colspan="3"><input type="text" id="newMailaddrDtl" name="newMailaddrDtl" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <td colspan="3"><input type="text" id="newMailstreet" name="newMailstreet" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td colspan="3"><input type="text" id="newMailarea" name="newMailarea" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">City</th>
    <td><span><input type="text" id="newMailcity" name="newMailcity" title="" placeholder="" class="w100p" /></span></td>
    <th scope="row">Postcode</th>
    <td><span><input type="text" id="newMailpostcode" name="newMailpostcode" title="" placeholder="" class="w100p" /></span></td>
</tr>
<tr>
    <th scope="row">State</th>
    <td><input type="text" title="" id="newMailstate" name="newMailstate" placeholder="" class="w100p" /></td>
    <th scope="row">Country</th>
    <td><input type="text" title="" id="newMailcountry" name="newMailcountry" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

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
    <th scope="row" rowspan="2">Delivery Address<span class="must">*</span></th>
    <td colspan="3"><input type="text" id="newDelvryaddrDtl" name="newDelvryaddrDtl" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <td colspan="3"><input type="text" id="newDelvrystreet" name="newDelvrystreet" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td colspan="3"><input type="text" id="newDelvryarea" name="newDelvryarea" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">City</th>
    <td><span><input type="text" id="newDelvrycity" name="newDelvrycity" title="" placeholder="" class="w100p" /></span></td>
    <th scope="row">Postcode</th>
    <td><span><input type="text" id="newDelvrypostcode" name="newDelvrypostcode" title="" placeholder="" class="w100p" /></span></td>
</tr>
<tr>
    <th scope="row">State</th>
    <td><input type="text" id="newDelvrystate" name="newDelvrystate" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Country</th>
    <td><input type="text" id="newDelvrycountry" name="newDelvrycountry" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

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
    <th scope="row">Name<span class="must">*</span></th>
    <td><input type="text" id="newMailContCntName" name="newMailContCntName" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Initial</th>
    <td><input type="text" id="newMailContDealerIniCd" name="newMailContDealerIniCd" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Gender</th>
    <td><input type="text" id="newMailContGender" name="newMailContGender" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input type="text" id="newMailContNric" name="newMailContNric" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Race</th>
    <td><input type="text" id="newMailContRaceName" name="newMailContRaceName" title="" placeholder="" class="w100p" /></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><input type="text" id="newMailContTelM1" name="newMailContTelM1" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel (Residence)</th>
    <td><input type="text" id="newMailContTelR" name="newMailContTelR" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel (Office)</th>
    <td><input type="text" id="newMailContTelO" name="newMailContTelO" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td><input type="text" id="newMailContTelF" name="newMailContTelF" title="" placeholder="" class="w100p" /></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

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
    <th scope="row">Name<span class="must">*</span></th>
    <td><input type="text" id="newDelvryContCntName" name="newDelvryContCntName" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Initial</th>
    <td><input type="text" id="newDelvryContDealerIniCd" name="newDelvryContDealerIniCd" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Gender</th>
    <td><input type="text" id="newDelvryContGender" name="newDelvryContGender" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input type="text" id="newDelvryContNric" name="newDelvryContNric" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Race</th>
    <td><input type="text" id="newDelvryContRaceName" name="newDelvryContRaceName" title="" placeholder="" class="w100p" /></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><input type="text" id="newDelvryContTelM1" name="newDelvryContTelM1" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel (Residence)</th>
    <td><input type="text" id="newDelvryContTelR" name="newDelvryContTelR" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel (Office)</th>
    <td><input type="text" id="newDelvryContTelO" name="newDelvryContTelO" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td><input type="text" id="newDelvryContTelF" name="newDelvryContTelF" title="" placeholder="" class="w100p" /></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Stock Item Request</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Currency</th>
    <td>
    <select id="curCd" name="curCd">
        <option value="">MYR</option>
        <option value="">SGD</option>
        <option value="">USD</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Currency Rate</th>
    <td><input type="text" title="" placeholder="" class="" /></td>
</tr>
<tr>
    <th scope="row">Total Unit</th>
    <td><input type="text" title="" placeholder="" class="" /></td>
</tr>
<tr>
    <th scope="row">Total Amount</th>
    <td><input type="text" title="" placeholder="" class="" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="left_btns">
    <li><p class="btn_blue2"><a href="#">Add Stock Item</a></p></li>
</ul>

<section class="search_result"><!-- search_result start 

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
-->
<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2"><a href="#">Save PST Request</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->