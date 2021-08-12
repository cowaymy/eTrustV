<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 08/02/2019  ONGHC  1.0.0          RE-STRUCTURE JSP.
 -->

<script type="text/javaScript">
  function fn_asAddRemark() {

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    var ordList = {
      "ordList" : selectedItems,
      "BRID" : "CSD001"
    }

    if ($("#addRemarkForm #callRem").val() == "") {
      Common.alert("* <spring:message code='sys.msg.necessary' arguments='Remark' htmlEscape='false'/> </br>");
      return;
    }

    Common.ajax("GET", "/services/as/addASRemark.do", $("#addRemarkForm")
        .serialize(), function(result) {

      if (result.code == "00") {
        Common.alert("* Remark successfully added.");
        fn_getCallLog();
        $("#_addASRemarkPopDiv").remove();
      }
    });
  }

  function fn_rstRmk() {
    $("#addRemarkForm #callRem").val("");
  }

</script>
<div id="popup_wrap" class="popup_wrap size_mid">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1><spring:message code='service.title.AddASRmk' /></h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <form action="#" method="post" id='addRemarkForm' name='addRemarkForm'>
   <section class="tap_wrap">
    <!-- tap_wrap start -->
    <ul class="tap_type1">
     <li><a href="#" class="on"><spring:message code='service.title.AddRmk' /></a></li>
    </ul>
    <article class="tap_area">
     <!-- tap_area start -->
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 130px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code='service.title.Remark' /><span class="must">*</span></th>
        <td><textarea id='callRem' name='callRem' rows='5'
          placeholder="<spring:message code='service.title.Remark' />" class="w100p"></textarea> <input type='hidden'
         id='asId' name='asId' value='${AS_ID}'>
        </textarea></td>
       </tr>
      </tbody>
     </table>
     <span style="color:red;"><spring:message code='service.msg.AddRmkNt' /></span><br><br>
     <!-- table end -->
     <ul class="center_btns">
      <li><p class="btn_blue2 big">
        <a href="#" onclick="fn_asAddRemark()"><spring:message code='sys.btn.add' /></a>
       </p></li>
      <li><p class="btn_blue2 big">
        <a href="#" onclick="fn_rstRmk()"><spring:message code='sys.btn.clear' /></a>
       </p></li>
     </ul>
    </article>
    <!-- tap_area end -->
   </section>
   <!-- tap_wrap end -->
  </form>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
