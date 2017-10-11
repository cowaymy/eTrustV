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
    <th scope="row">BS Availability</th>
    <td><span>${orderDetail.orderCfgInfo.configBsGen}</span></td>
    <th scope="row">BS Frequency</th>
    <td><span>${orderDetail.orderCfgInfo.srvMemFreq} month(s)</span></td>
    <th scope="row">Last BS Date</th>
    <td><span>${orderDetail.orderCfgInfo.setlDt}</span></td>
</tr>
<tr>
    <th scope="row">BS Cody Code</th>
    <td colspan="5"><span>${orderDetail.orderCfgInfo.memCode} - ${orderDetail.orderCfgInfo.name}</span></td>
</tr>
<tr>
    <th scope="row">Config Remark</th>
    <td colspan="5"><span>${orderDetail.orderCfgInfo.configBsRem}</span></td>
</tr>
<tr>
    <th scope="row">Happy Call Service</th>
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
    <span>Installation Type</span></label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettBs == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
    <span>BS Type</span></label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettAs == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
    <span>AS Type</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Prefer BS Week</th>
    <td colspan="5">
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 0 || orderDetail.orderCfgInfo.configBsWeek > 4}">checked</c:if> disabled/><span>None</span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 1}">checked</c:if> disabled/><span>Week1</span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 2}">checked</c:if> disabled/><span>Week2</span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 3}">checked</c:if> disabled/><span>Week3</span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 4}">checked</c:if> disabled/><span>Week4</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->
