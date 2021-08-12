<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" /> 
</colgroup>
<tbody>

<tr>
    <th scope="row"><spring:message code="sales.ContactPerson" /></th>
    <td colspan="7"><span  id="inc_cntName"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.NRIC" /></th>
    <td colspan="3"><span  id="inc_cntNric"></span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span  id="inc_cntGender"></span></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span id="inc_cntRace"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td><span><span  id="inc_cntTelM"></span></span></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><span  id="inc_cntTelR"></span></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><span id="inc_cntTelO"></span></td>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><span id="inc_cntTelF"></span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td colspan="7" id="inc_cntEmail" ><span></span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->



<script> 

/*cPerson*/ 
function fn_getDataCPerson (_CUST_ID){
    Common.ajax("GET", "/sales/membership/selectMembershipFree_cPerson", {CUST_ID:_CUST_ID}, function(result) {
        
    	console.log( "fn_getDataCPerson===>");
    	console.log( result);
        
       // fn_doClearPersion();
         
        $("#inc_cntName").html(result[0].name);
        $("#inc_cntGender").html(result[0].gender);
        $("#inc_cntNric").html(result[0].nric);
        $("#inc_cntRace").html(result[0].codename1);
        $("#inc_cntTelM").html(result[0].telM1);
        $("#inc_cntTelO").html(result[0].telO);
        $("#inc_cntTelR").html(result[0].telR);
        $("#inc_cntTelF").html(result[0].telf);
        $("#inc_cntEmail").html(result[0].email);
       
         
    });
  }

</script> 
