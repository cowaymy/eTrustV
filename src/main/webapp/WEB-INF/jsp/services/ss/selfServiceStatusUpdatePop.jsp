<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
var statusType = [{"codeId": "21","codeName": "Failed"}];
var ssResultId = '${ssResultId}';
var salesOrdId = '${salesOrdId}';
var schdulId = '${schdulId}';

  $(document).ready(
    function() {
    	doDefCombo(statusType, '' ,'ssStatus', 'S', '');
    	$("#ssStatus option[value='"+ 21 +"']").attr("selected", true);
      $('#btnLedger').click(function() {
        Common.popupWin("frmLedger", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
      });

  });

  $(function(){
	  $('#btnSaveStatus').click(
		      function() {
		        var updateSelfServiceStatus = function() {
		          var data = { ssResultId : ssResultId,
		        		  	   schdulId : schdulId,
		        		  	   salesOrdId : salesOrdId,
		                       ssStusId : $("#ssStatus").val(),
		                       ssFailReason : $("#ssFailReason").val(),
		                       ssRemark : $("#ssRemark").val().replace(/[\r\n]+/g, ' ').replace(/'/g, '"')
		          };

		          Common.ajax("POST", "/services/ss/updateSelfServiceResultStatus.do", data,
		            function(result) {
		              Common.alert(result.message, fn_popClose);
		              $("#popup_wrap").remove();
		            },
		            function(error) {
		              Common.alert("An error occurred while updating Self Service Status]: " + error.message);
		          });
		        };

		        updateSelfServiceStatus();
		    });
  });

  function fn_popClose() {
    $("#_systemClose").click();
    fn_parentReload();
  }

</script>
<div id="popup_wrap" class="popup_wrap">
  <form id="frmLedger" name="frmLedger" action="#" method="post">
    <input id="ordId" name="ordId" type="hidden" value="${basicinfo.salesOrdId}" />
  </form>
  <header class="pop_header">
    <h1>
      <spring:message code="service.ss.title.selfServiceManagement" /> - <spring:message code="service.ss.btn.selfServiceStatusUpdate" />
    </h1>
    <ul class="right_opt">
      <li>
        <p class="btn_blue2">
          <a id="btnLedger" href="#"><spring:message code="sal.btn.ledger" /></a>
        </p>
      </li>
      <li>
        <p class="btn_blue2">
          <a id="_systemClose"><spring:message code="sal.btn.close" /></a>
        </p>
      </li>
    </ul>
  </header>
  <section class="pop_body">
    <aside class="title_line">
      <h3><spring:message code="service.ss.text.selfServiceInformation" /></h3>
    </aside>
    <table class="type1">
      <caption>table</caption>
      <colgroup>
        <col style="width: 120px" />
        <col style="width: *" />
        <col style="width: 120px" />
        <col style="width: *" />
        <col style="width: 120px" />
        <col style="width: *" />
      </colgroup>
      <tbody>
      <tr>
    	<th scope="row"><spring:message code="service.grid.HSNo" /></th>
    	<td><span><c:out value="${basicinfo.no}"/></span></td>
    	<th scope="row"><spring:message code="service.ss.title.ssPeriod" /></th>
    	<td><span><c:out value="${basicinfo.monthy}"/></span></td>
    	<th scope="row"><spring:message code="sal.text.bsType" /></th>
    	<td><span><c:out value="${basicinfo.codeName}"/></span></td>
		</tr>
      </tbody>
    </table>

    <section class="tap_wrap">
      <!------------------------------------------------------------------------------
        Detail Page Include START
      ------------------------------------------------------------------------------->
      <%@ include
        file="/WEB-INF/jsp/services/ss/selfServiceDetailContent.jsp"%>
      <!------------------------------------------------------------------------------
        Detail Page Include END
      ------------------------------------------------------------------------------->
    </section>

      <section>
      <aside class="title_line">

      </aside>
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 40%" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="service.title.HSStatus" /><span class="must">**</span></th>
            <td colspan="2"><select id="ssStatus" name="ssStatus" class="w100p"></select></td>
          </tr>
          <tr>
           <th scope="row"><spring:message code="sal.title.failReason" /></th>
    		<td colspan="2"><select class="w100p" id ="ssFailReason"  name ="ssFailReason">
       			<c:forEach var="list" items="${failReasonList}" varStatus="status">
             		<option value="${list.codeId}">${list.codeName } </option>
        		</c:forEach>
    			</select>
    		</td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.title.remark" /></th>
            <td colspan="2">
              <textarea id="ssRemark" name="ssRemark" cols="20" rows="5"></textarea>
            </td>
          </tr>
        </tbody>
      </table>
      <ul class="center_btns mt20">
        <li>
          <p class="btn_blue2 big">
            <a id="btnSaveStatus" href="#"><spring:message code="sys.btn.save" /></a>
          </p>
        </li>
      </ul>
    </section>


  </section>
</div>