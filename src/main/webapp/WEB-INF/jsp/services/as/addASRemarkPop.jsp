<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


function fn_asAddRemark(){
    

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    var ordList ={
             "ordList":selectedItems,
             "BRID" : "CSD001"
    }
    
    
    
    Common.ajax("GET", "/services/as/addASRemark.do", $("#addRemarkForm").serialize(), function(result) {
        console.log("fn_asAddRemark.");
        console.log(result);
        
        if(result.code =="00"){
            Common.alert("* Remark successfully saved.");
            fn_getCallLog();
            $("#_addASRemarkPopDiv").remove();
        }
    });
}
</script>


<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>ADD AS REMARK</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post"  id='addRemarkForm'  name='addRemarkForm' >

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Add Remark </a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->



<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Remark</th>
    <td>
       <textarea  id='callRem' name='callRem'   rows='5' placeholder=""  class="w100p" ></textarea>
       
        <input  type='hidden' id='asId' name='asId'  value='${AS_ID}'></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#"  onclick="fn_asAddRemark()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#"  onclick="javascript:$('#callRem').val('')" >Clear</a></p></li>
</ul>

</article><!-- tap_area end -->


</section><!-- tap_wrap end -->

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
