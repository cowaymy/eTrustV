
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript" language="javascript">
    
    
   function fn_goProcess(){
	   
	   fn_DoSaveProcess($("#saveOption").val());
	   $("#ms_close").click();
   }
   
    
 </script>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Save Option</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="ms_close">CLOSE</a></p></li>
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
    <th scope="row">Save Option</th>
    <td>
    <select id="saveOption" name="saveOption" >
        <option value="1" selected>Save & proceed to payment</option>
        <option value="2">Save quotation only</option>
    </select>
    </td>
</tr>
</tbody>
</table>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#"  onclick="javascript:fn_goProcess()">Proceed</a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->


<script> 
</script>