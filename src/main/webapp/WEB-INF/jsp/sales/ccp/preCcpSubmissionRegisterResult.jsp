<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<div id="popup_wrap_result" class="popup_wrap">
  <header class="pop_header">
        <h1>Pre-CCP Register Result</h1>
         <ul class="right_opt">
                <li><p class="btn_blue2"><a id="btnPopResultClose"  javascript:void(0);><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
  </header>


<section class="pop_body">
      <table class="type1">
            <caption>table</caption>
            <colgroup>
                  <col style="width:160px" />
                  <col style="width:*" />
            </colgroup>

            <tbody>
                    <tr>
                       <th scope="row">Name</th>
                       <td>${preccpResult.custName}</td>
                    </tr>

                     <tr>
                       <th scope="row">Customer ID</th>
                       <td>${preccpResult.custId}</td>
                     </tr>

                     <tr>
                       <th scope="row">CHS Status</th>
                       <td>${preccpResult.result}</td>
                     </tr>
           </tbody>
      </table>
</section>
</div>

<script>

$(function(){
       document.getElementById('btnPopResultClose').onclick = (event) => {
            location.reload();
       }
});

</script>