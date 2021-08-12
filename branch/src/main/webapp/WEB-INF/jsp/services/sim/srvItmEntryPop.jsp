<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 27/06/2019  ONGHC  1.0.0          CREATE FOR SERVICE ITEM MANEGEMENT
 29/08/2019  ONGHC  1.0.1          Enhance to Support DSC Branch
 -->

<script type="text/javaScript">
  $(document).ready( function() {
    // SET CBO LISING HERE --
    doGetCombo('/services/sim/getBchTyp.do', '', '${BR_TYP_ID}', 'cboBchTypPop', 'S', 'fn_onChgBch'); // BRANCH TYPE
    doGetCombo('/services/sim/getItm.do', '', '', 'cboItmPop', 'S', ''); // ITEM TYPE

    // SET TRIGGER FUNCTION HERE --
    $("#cboBchTypPop").change(function() {
      doGetCombo('/services/sim/getBch.do', $("#cboBchTypPop").val(), '', 'cboBchPop', 'S', '');
    });
  });

  function fn_onChgBch() {
    doGetCombo('/services/sim/getBch.do', $("#cboBchTypPop").val(), '${SESSION_INFO.userBranchId}', 'cboBchPop', 'S', '');

    if($("#cboBchTypPop option[value='${BR_TYP_ID}']").length == 0) {
      $('#cboBchTypPop').removeAttr("disabled");
    }
  }

  function fn_next() {
    // VALIDATION BEFORE NEXT
    var bchTyp = $('#cboBchTypPop').val();
    var bch = $('#cboBchPop').val();
    var itmCde = $('#cboItmPop').val();
    var text;

    if (bchTyp == "" || bchTyp == null) {
      text = "<spring:message code='service.grid.brchTyp'/>";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
      return;
    }
    if (bch == "" || bch == null) {
      text = "<spring:message code='service.grid.bch'/>";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
      return;
    }
    if (itmCde == "" || itmCde == null) {
      text = "<spring:message code='sal.title.item'/>";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
      return;
    }

    fn_addSrvItm(bchTyp, bch, itmCde);
    $("#_NewEntryPopDiv1").remove();
  }

  function fn_selfClose() {
    $('#btnClose').click();
    $("#_NewEntryPopDiv1").remove();
  }

</script>
<div id="popup_wrap" class="popup_wrap">
 <section id="content">

  <header class="pop_header">
   <h1><spring:message code='service.title.srvItmMgmt'/></h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a id="btnClose" href="#"><spring:message code='sys.btn.close'/></a>
     </p></li>
   </ul>
  </header>

  <section class="pop_body">
   <section class="search_table">
    <form action="#" method="post" id="srvItmEntryForm" onsubmit="return false;">
     <table class="type1">
      <caption>table</caption>
      <colgroup>
       <col style="width: 120px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code='service.grid.brchTyp'/><span class='must'> *</span></th>
        <td><select id="cboBchTypPop" name="cboBchTypPop" class="w100p" disabled/></td>
       </tr>
       <tr>
         <th scope="row"><spring:message code='service.grid.bch'/><span class='must'> *</span></th>
          <td>
            <select id="cboBchPop" name="cboBchPop" class="w100p" >
              <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
            </select>
          </td>
       </tr>
       <tr>
         <th scope="row"><spring:message code='sal.title.item'/><span class='must'> *</span></th>
         <td>
           <select id="cboItmPop" name="cboItmPop" class="w100p" />
         </td>
       </tr>
      </tbody>
     </table>
     <p class="btn_blue2 big" align="center">
       <a href="#" onclick="fn_next()"><spring:message code='sys.btn.next'/></a>
     </p>
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