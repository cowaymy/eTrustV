<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">

var date = new Date().getDate();
var mon = new Date().getMonth()+1;
if(date.toString().length == 1){
    date = "0" + date;
}
if(mon.toString().length == 1){
    mon = "0" + mon;
}
$("#dpRequestDtFrom").val("01/"+mon+"/"+new Date().getFullYear());
$("#dpRequestDtTo").val(date+"/"+mon+"/"+new Date().getFullYear());
$("#dpReturnDtFrom").val("01/"+mon+"/"+new Date().getFullYear());
$("#dpReturnDtTo").val(date+"/"+mon+"/"+new Date().getFullYear());

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
        $("#dpRequestDtFrom").val("01/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpRequestDtTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

        $("#dpReturnDtFrom").val("01/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpReturnDtTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

    });
};

function btnGenerate_Click(){

    var whereSQL = "";
    var runNo = 0;


    if(!($("#dpRequestDtFrom").val() == null || $("#dpRequestDtFrom").val().length == 0)){
        whereSQL += " AND c.SO_REQ_CRT_DT >= TO_DATE('"+$("#dpRequestDtFrom").val()+"', 'dd/MM/YYYY') ";
    }

    if(!($("#dpRequestDtTo").val() == null || $("#dpRequestDtTo").val().length == 0)){
        whereSQL += " AND c.SO_REQ_CRT_DT < TO_DATE('"+$("#dpRequestDtTo").val()+"', 'dd/MM/YYYY')+1 "; //AddDays(1)
    }

    if(!($("#dpReturnDtFrom").val() == null || $("#dpReturnDtFrom").val().length == 0)){
        whereSQL += " AND c.SO_REQ_CRT_DT >= TO_DATE('"+$("#dpReturnDtFrom").val()+"', 'dd/MM/YYYY') ";
    }

    if(!($("#dpReturnDtTo").val() == null || $("#dpReturnDtTo").val().length == 0)){
        whereSQL += " AND c.SO_REQ_CRT_DT < TO_DATE('"+$("#dpReturnDtTo").val()+"', 'dd/MM/YYYY')+1 "; //AddDays(1)
    }



    $("#V_WHERESQL").val(whereSQL);

    $("#reportDownFileName").val("OrderCancellationRequestRaw_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#reportFileName").val("/sales/OrderCancellationRequestRawData.rpt");
    $("#viewType").val("EXCEL");

    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);

}



</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Cancellation Product Return Raw</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

<table class="type1"><!-- table start -->
<caption>table</caption>

<tbody>
<tr>

    <th scope="row"><spring:message code="sal.text.requestDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Request start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpRequestDtFrom"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Request end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpRequestDtTo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Return Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Return start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReturnDtFrom"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Return end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReturnDtTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>

</tbody>
</table><!-- table end -->



<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="">

</form>



<div style="height: 80px">
</div>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Click()"><spring:message code="sal.btn.generate" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->