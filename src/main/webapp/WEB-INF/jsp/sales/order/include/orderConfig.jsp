<script type="text/javaScript" language="javascript">
var srvType = "${orderDetail.orderCfgInfo.srvType}";

$(document).ready(function(){
	fn_checkPreSrvType(srvType);
});

function fn_checkPreSrvType(val){
	  var preSrvType = val;
	  if(preSrvType == "HS"){
		  $('[name="srvType"]').prop("disabled", true);
		  $('#srvTypeHS').prop("checked", true);
	  }else if(preSrvType == "SS"){
		  $('[name="srvType"]').prop("disabled", true);
		  $('#srvTypeSS').prop("checked", true);
	  }else{
		  $('[name="srvType"]').prop("disabled", true);
		  $('#srvTypeHS').prop("checked", true);
	  }
}

</script>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.bsAvail" /></th>
    <td><span>${orderDetail.orderCfgInfo.configBsGen}</span></td>
    <th scope="row"><spring:message code="sal.text.bsFrequency" /></th>
    <td><span>${orderDetail.orderCfgInfo.srvMemFreq} month(s)</span></td>
    <th scope="row"><spring:message code="sal.text.lastBsDt" /></th>
    <td><span>${orderDetail.orderCfgInfo.setlDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.srvType'/></th>
    <td colspan="5">
    <input id="srvTypeHS" name="srvType" type="radio" value="HS" /><span><spring:message code='sales.text.heartService'/></span>
    <input id="srvTypeSS" name="srvType" type="radio" value="SS" /><span><spring:message code='sales.text.selfService'/></span>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.srvTypeChangeCount'/></th>
    <td colspan="5"><span>${orderDetail.orderCfgInfo.srvCount}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.bsCodyCd" /></th>
    <td colspan="5"><span>${orderDetail.orderCfgInfo.memCode} - ${orderDetail.orderCfgInfo.name}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.configRem" /></th>
    <td colspan="5"><span>${orderDetail.orderCfgInfo.configBsRem}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.happyCallSvc" /></th>
    <td colspan="5">
    <label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettIns == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
    <span><spring:message code="sal.text.instType" /></span></label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettBs == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
    <span><spring:message code="sal.text.bsType" /></span></label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettAs == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
    <span><spring:message code="sal.text.asType" /></span></label>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.preferBsWeek" /></th>
    <td colspan="5">
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 0 || orderDetail.orderCfgInfo.configBsWeek > 4}">checked</c:if> disabled/><span><spring:message code="sal.text.none" /></span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 1}">checked</c:if> disabled/><span><spring:message code="sal.text.week1" /></span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 2}">checked</c:if> disabled/><span><spring:message code="sal.text.week2" /></span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 3}">checked</c:if> disabled/><span><spring:message code="sal.text.week3" /></span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 4}">checked</c:if> disabled/><span><spring:message code="sal.text.week4" /></span></label>
    </td>
</tr>
<tr>
  <th scope="row"><spring:message code="service.title.AppointmentDate" /></th>
  <td colspan="5">
    <ul class="btns">
      <li>
        <p class="btn_grid">
          <a href="#" onClick=
            "{Common.popupDiv('/sales/order/getHSAppointmentDate.do', { ordNo : '${orderDetail.basicInfo.ordNo}' }, null , true);}"><spring:message code='sys.btn.view' /></a>
        </p>
       </li>
      </ul>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->
