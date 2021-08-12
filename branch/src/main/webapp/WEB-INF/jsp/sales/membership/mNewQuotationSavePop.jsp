
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript" language="javascript">
    
    
   function fn_goProcess(){
	   
	 fn_DoSaveProcess($("#saveOption").val());
	 $("#_saveDiv1").remove();
	   
   }
   
    
 </script>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.saveOption" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2" ><a href="#" id="ms_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row"><spring:message code="sal.text.saveOption" /></th>
    <td>
    <select id="saveOption" name="saveOption" >
        <option value="1" selected><spring:message code="sal.text.saveProceedPayment" /></option>
        <option value="2"><spring:message code="sal.text.saveQuotation" /></option>
    </select>
    </td>
</tr>
</tbody>
</table>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#"  onclick="javascript:fn_goProcess()"><spring:message code="sal.btn.proceed" /></a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->


<script> 
</script>