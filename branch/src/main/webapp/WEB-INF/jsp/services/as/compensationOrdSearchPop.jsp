<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/04/2019  ONGHC  1.0.0          RE-STRUCTURE JSP
 -->

<script type="text/javaScript">
  $(document).ready(function() {
  });

  function fn_keyEvent() {
    $("#entry_orderNo").keydown(function(key) {
      if (key.keyCode == 13) { // ENTER
        fn_selOrdNo()
      }
    });
  }

  function fn_goOrdSearch() {
    Common.popupDiv('/sales/ccp/searchOrderNoPop.do', null, null, true, '_searchDiv');
  }

  function fn_callbackOrdSearchFunciton(item) {
    $("#entry_orderNo").val(item.ordNo);
  }


  function fn_selOrdNo() {
    if ($("#entry_orderNo").val() == "") {
      var field = "<spring:message code='service.title.OrderNo' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='* <b>" +field + "</b>' htmlEscape='false'/>");
      return;
    }

    Common.ajax("GET", "/services/compensation/verifyOrdNo.do", { orderNo : $("#entry_orderNo").val() },
      function(result) {
      console.log(result);
        if (result == null) {
          Common.alert("<b>* Order Number Not Found. </b>")
          return;
        } else {
          console.log(result.salesOrdId);
          fn_compPop($("#entry_orderNo").val(), result.salesOrdId);
          $("#_NewEntryPopDiv1").remove();
        }
      });
  }

  function fn_selfClose() {
    $('#btnClose').click();
    $("#_resultNewEntryPopDiv1").remove();
  }

</script>
<div id="popup_wrap" class="popup_wrap" style='overflow:hidden;'>
 <!-- popup_wrap start -->
 <section id="content">
  <!-- content start -->
  <header class="pop_header">
   <!-- pop_header start -->
   <h1><spring:message code="service.title.CpsOrdSearch" /></h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a id="btnClose" href="#"><spring:message code="sys.btn.close" /></a>
     </p></li>
   </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
   <!-- pop_body start -->
   <section class="search_table">
    <!-- search_table start -->
    <form action="#" method="post" id="" onsubmit="return false;">
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 100px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code="service.title.OrderNo" /> <span class='must'> *</span></th>
        <td>
         <input type="text" title="" placeholder="" class="" id="entry_orderNo" name="entry_orderNo" />
         <p class="btn_sky">
          <a href="#" onClick="fn_selOrdNo()"><spring:message code="sys.btn.confirm" /></a>
         </p>
         <p class="btn_sky">
          <a href="#" onclick="fn_goOrdSearch()"><spring:message code="sys.btn.search" /></a>
         </p>
        </td>
       </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
   </section>
   <!-- search_table end -->
  </section>
  <!-- content end -->
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->