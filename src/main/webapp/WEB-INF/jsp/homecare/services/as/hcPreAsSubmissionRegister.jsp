<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    $(document).ready(function() {

            hideDetails();

            $('#registerOrderNumBtn').click(function() {

                 if (FormUtil.isEmpty($("#registerOrderNum").val())) {
                      Common.alert("Please key in Order Number.");
                      return false;
                  }
                 else{
                         Common.ajax("GET", "/services/as/checkOrder.do", $("#registerForm").serialize(), function(result) {
                             Common.alert(result.message);
                             $("#registerOrderNum").val(result.data.registerOrderNum);

                             if(result.code == "00"){
                                 var param = {prodCat :result.data.prodCat};
                                 doGetCombo('/services/as/getErrorCodeList.do', param, '', 'registerErrorCode', 'S', 'showDetails');
                             }else {
                                 hideDetails();
                             }
                     });
                 }
            });
    });

   $(function(){

          $('#registerOrderNum').keyup(function (e){
              hideDetails();
          });

          $('#saveRequestBtn').click(function (e){
              if (validateUpdForm()){

                  var param = {
                          registerOrderNum : $("#registerOrderNum").val(),
                          defectCode :  $("#registerErrorCode").val(),
                          remark :  $("#registerRemark").val(),
                          orderType : "HC"
                 }

                   Common.ajax("POST", "/services/as/submitPreAsSubmission.do", param, function(result) {
                       if(result.code =="00"){
                           Common.alert("Success to create.",fn_reload);
                       }

                   }, function(jqXHR, textStatus, errorThrown) {
                       try {
                           console.log("status : " + jqXHR.status);
                           console.log("code : " + jqXHR.responseJSON.code);
                           console.log("message : " + jqXHR.responseJSON.message);
                           console.log("detailMessage : "+ jqXHR.responseJSON.detailMessage);
                           Common.alert("Fail: " + jqXHR.responseJSON.message);
                       } catch (e) {
                           console.log(e);
                           Common.alert("Fail: " + e);
                       }

                   });
              }
          });
   });

   function hideDetails(){

           $("#registerErrorCode").val("");
           $("#registerErrorCode").attr("class", "w100p readonly");
           $("#registerErrorCode").attr("disabled", true);


           $("#registerRemark").val("");
           $("#registerRemark").attr("class", "w100p readonly");
           $("#registerRemark").attr("disabled", true);
   }


   function showDetails(){

           $("#registerErrorCode").attr("class", "w100p");
           $("#registerErrorCode").attr("disabled", false);

           $("#registerRemark").attr("class", "w100p");
           $("#registerRemark").attr("disabled", false);

   }

   function validateUpdForm() {
       if (FormUtil.isEmpty($("#registerOrderNum").val())) {
           Common.alert("Please key in Order Number.");
           return false;
       }

       if (FormUtil.isEmpty($("#registerErrorCode").val())) {
           Common.alert("Please choose Error Code.");
           return false;
       }

       if (FormUtil.isEmpty($("#registerRemark").val())) {
           Common.alert("Please key in Remark.");
           return false;
       }

       return true;
   }

   function fn_reload(){
       location.reload();
   }



</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
  <header class="pop_header"><!-- pop_header start -->
        <h1>Register</h1>

        <ul class="right_opt">
         <li><p class="btn_blue2"><a id="btnPopClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
  </header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->

    <form action="#" method="post" name="registerForm" id="registerForm">
    <input type="hidden" name="orderType" id="orderType" value="HC"/>
      <table class="type1"><!-- table start -->
        <caption>table</caption>

        <colgroup>
          <col style="width:160px" />
          <col style="width:*" />
        </colgroup>
        <tbody>

        <tr>
          <th scope="row"><spring:message code='service.title.OrderNumber' /></th>
           <td>
                <input type="text" id="registerOrderNum" name="registerOrderNum" />
                <a id="registerOrderNumBtn" href="#" class="search_btn">
                <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                </a>
           </td>
        </tr>



          <tr>
            <th scope="row">Error Code</th>
            <td><select class="w100p" id="registerErrorCode" name="registerErrorCode"></select></td>
          </tr>


          <tr>
            <th scope="row">Remarks</th>
            <td><textarea cols="20" rows="2" type="text" id="registerRemark" name="registerRemark" maxlength="200" placeholder="Remarks"/></td>
          </tr>
        </tbody>
      </table><!-- table end -->

      <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" id="saveRequestBtn">Save</a></p></li>
        <li><p class="btn_blue2 big"><a href="#" id="cancelRequestBtn">Cancel</a></p></li>
      </ul>

</form>
</section>


</div><!-- popup_wrap end -->