<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/04/2019  ONGHC  1.0.0          RE-STRUCTURE JSP
 26/04/2019  ONGHC  1.0.1          ADD RECALL STATUS
 -->

<!-- AS ORDER > AS MANAGEMENT > CREATE AS ENTRY POP -->
<script type="text/javaScript">
  function fn_ASSave() {
    Common.ajax("GET", "/services/as/addASNo.do", {}, function(result) {
    });
  }

  function fn_confirmOrder() {
    if ($("#entry_orderNo").val() == "") {
      var field = "<spring:message code='service.title.OrderNo' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='* <b>" +field + "</b>' htmlEscape='false'/>");
      return;
    }

    Common.ajax("GET", "/services/as/searchOrderNo", { orderNo : $("#entry_orderNo").val() },
      function(result) {
        if (result == null) {
          Common.alert("<spring:message code='service.msg.asOrdNtFound' />");
          $("#Panel_AS").attr("style", "display:none");
          return;
        } else {
          fn_resultASPop(result.ordId, result.ordNo);
          $("#_NewEntryPopDiv1").remove();
        }
      });
  }

  $(document).ready(function() {
    fn_keyEvent();

    if ('${ORD_NO}' != "") {
      $("#entry_orderNo").val('${ORD_NO}');
      //fn_confirmOrder();
      fn_checkASReceiveEntryConfirmation();
    }
    if('${PREAS_ORDNO}' != ""){
    	$("#entry_orderNo").attr("class", "readonly");
        $("#entry_orderNo").attr("readonly", "readonly");
    	$("#entry_orderNo").val('${PREAS_ORDNO}');
    	 fn_checkASReceiveEntryConfirmation();
    }

  });

  function fn_getOrderDetailListAjax() {
    Common.ajax("GET", "/sales/order/orderTabInfo", { salesOrderId : _selSalesOrdId }, function(result) {
    });
  }

  function fn_keyEvent() {
    $("#entry_orderNo").keydown(function(key) {
      if (key.keyCode == 13) {
        //fn_confirmOrder();
        fn_checkASReceiveEntryConfirmation();
      }
    });
  }

  function fn_goCustSearch() {
    Common.popupDiv('/sales/ccp/searchOrderNoPop.do', null, null, true, '_searchDiv');
  }

  function fn_callbackOrdSearchFunciton(item) {
    $("#entry_orderNo").val(item.ordNo);
    //fn_confirmOrder();
  }

  function fn_loadPageControl() {
    /*
    CodeManager cm = new CodeManager();
    IList<Data.CodeDetail> atl = cm.GetCodeDetails(10);

    ddlAppType_Search.DataTextField = "CodeName";
    ddlAppType_Search.DataValueField = "Code";
    ddlAppType_Search.DataSource = atl.OrderBy(itm=>itm.CodeName);
    ddlAppType_Search.DataBind();

    ASManager asm = new ASManager();
    List<ASReasonCode> ecl = asm.GetASErrorCode();
    ddlErrorCode.DataTextField = "ReasonCodeDesc";
    ddlErrorCode.DataValueField = "ReasonID";
    ddlErrorCode.DataSource = ecl.OrderBy(itm=>itm.ReasonCode);
    ddlErrorCode.DataBind();

    List<Data.Branch> dscl = cm.GetBranchCode(2, "-");
    ddlDSC.DataTextField = "Name";
    ddlDSC.DataValueField = "BranchID";
    ddlDSC.DataSource = dscl.OrderBy(itm=>itm.Code);
    ddlDSC.DataBind();

    List<ASMemberInfo> ctl = asm.GetASMember();
    ddlCTCode.DataTextField = "MemCodeName";
    ddlCTCode.DataValueField = "MemID";
    ddlCTCode.DataSource = ctl.OrderBy(itm=>itm.MemCode);
    ddlCTCode.DataBind();

    IList<Data.CodeDetail> rql = cm.GetCodeDetails(24);
    ddlRequestor.DataTextField = "CodeName";
    ddlRequestor.DataValueField = "CodeID";
    ddlRequestor.DataSource = rql.OrderBy(itm => itm.CodeName);
    ddlRequestor.DataBind();
     */
  }

  //AS RECEIVED ENTRY POP UP NOTIFICATION -- TPY
  function fn_checkASReceiveEntry() {
    Common.ajaxSync("GET", "/services/as/checkASReceiveEntry.do", { salesOrderNo : $("#entry_orderNo").val()
    }, function(result) {
      msg = result.message;
    });
    return msg;
  }

  function fn_checkASReceiveEntryConfirmation() {
    if ($("#entry_orderNo").val() == "" ) {
      var field = "<spring:message code='service.title.OrderNo' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='* <b>" +field + "</b>' htmlEscape='false'/>");
      return;
    }



    Common.ajax("GET", "/services/as/searchOrderNo", { orderNo : $("#entry_orderNo").val() },
      function(result) {
        if (result == null) {
          Common.alert("<spring:message code='service.msg.asOrdNtFound' />");
          $("#Panel_AS").attr("style", "display:none");
          return;
        } else {
          var msg = fn_checkASReceiveEntry();

          if (msg == "") {
            fn_resultASPop(result.ordId, result.ordNo);
            $("#_NewEntryPopDiv1").remove();
          } else {
             msg += "<br/> <spring:message code='service.msg.doPrc' /> <br/>";

             Common.confirm("<spring:message code='service.title.asRecvEntConf' />"
                              + DEFAULT_DELIMITER
                              + "<b>" + msg
                              + "</b>",
                            fn_resultASPop(result.ordId, result.ordNo),
                            fn_selfClose);
          }
          $("#_NewEntryPopDiv1").remove()
        }
      });
  }

  function fn_selfClose() {
    $('#btnClose').click();
    //$("#_resultNewEntryPopDiv1").remove();
    $("#_NewEntryPopDiv1").remove();
  }

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <section id="content">
  <!-- content start -->
  <header class="pop_header">
   <!-- pop_header start -->
   <h1><spring:message code='service.btn.crtAs'/></h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a id="btnClose" href="#" ><spring:message code='sys.btn.close'/></a>
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
       <col style="width: 150px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code='service.title.OrderNo'/><span class="must">*</span></th>
        <td>
          <input type="text" title="" placeholder="" class="" id="entry_orderNo" name="entry_orderNo" />
          <p class="btn_sky">
            <a href="#" onClick="fn_checkASReceiveEntryConfirmation()"><spring:message code='pay.combo.confirm'/></a>
           </p>
           <p class="btn_sky">
            <a href="#" onclick="fn_goCustSearch()"><spring:message code='sys.btn.search'/></a>
           </p></td>
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