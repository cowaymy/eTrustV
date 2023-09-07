<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<style type="text/css">
    .aui-grid-user-custom-left {
        text-align:left;
    }

    .aui-grid-user-custom-right {
        text-align:right;
    }

    .auto_file4{position:relative; width:237px; padding-right:62px; height:20px;}
    .auto_file4{float:none!important; width:490px; padding-right:0; margin-top:5px;}
    .auto_file4:first-child{margin-top:0;}
    .auto_file4:after{content:""; display:block; clear:both;}
    .auto_file4.w100p{width:100%!important; box-sizing:border-box;}
    .auto_file4 input[type=file]{display:block; overflow:hidden; position:absolute; top:-1000em; left:0;}
    .auto_file4 label{display:block; margin:0!important;}
    .auto_file4 label:after{content:""; display:block; clear:both;}
    .auto_file4 label{float:left; width:300px;}
    .auto_file4 label input[type=text]{width:100%!important;}
    .auto_file4 label input[type=text]{width:237px!important; float:left}
    .auto_file4.attachment_file label{float:left; width:407px;}
    .auto_file4.attachment_file label input[type=text]{width:345px!important; float:left}
    .auto_file4 span.label_text2{float:left;}
    .auto_file4 span.label_text2 a{display:block; height:20px; line-height:20px; margin-left:5px; min-width:47px; text-align:center; padding:0 5px; background:#a1c4d7; color:#fff; font-size:11px; font-weight:bold; border-radius:3px;}
</style>

<div id="popup_wrap" class="popup_wrap">

    <header class="pop_header">
        <h1>Payment Confirmation</h1>
            <ul class="right_opt">
        <li><p class="btn_blue2"><a id="btnCloseStock">CLOSE</a></p></li>
        </ul>
    </header>


    <section class="pop_body" style="min-height: auto;">

    <section class="search_table">
    <form action="#" method="post" id="stockForm">
        <table class="type1">
        <caption>table</caption>
        <colgroup>
           <col style="width:150px" />
           <col style="width:*" />
           <col style="width:150px" />
           <col style="width:*" />
        </colgroup>
           <tbody>

             <tr>
                  <th colspan="1">Grand Total Price (RM)</th>
                  <td colspan="2"><div id="grandTotalPrice" style="width: 100%; text-align: end;"></div></td>
                  <th colspan="3"></th>

             </tr>
             <tr>
                  <th scope="row" >Attachment<span class="must">*</span></th>
                  <td>

                  <div id="quotaFileInput" class="auto_file4" style="width: auto;">
                         <input type="file" id="attachmentPaySlip" name="attachmentPaySlip" title="file add" />
                         <label for="quotaFileInput">
                             <input id="quotaFile" type="text" class="input_text" readonly class="readonly">
                             <span class="label_text2"><a href="#">Upload</a></span>
                         </label>
                  </div>
                  </td>
                  <th colspan="4"></th>
              </tr>
            </tbody>
        </table>
    </form>

    <ul class="center_btns">
            <li><p class="btn_blue2 big"><a id="btnConfirmPayment">Save</a></p></li>
            <li><p class="btn_blue2 big"><a id="btnCancelPayment">Cancel</a></p></li>
    </ul>
    </section>
</div>

<script>

  let {esnNo , totalPrice, shippingFee} =  ${paymentInfo};

  let total =  Number(totalPrice) + Number(shippingFee);

  document.getElementById("grandTotalPrice").innerHTML = `<b style="font-size: 15px;">` + total.toFixed(2) + "</b>";

  document.querySelectorAll(".auto_file4 label").forEach(label => {
      label.onclick = () => {
          label.parentElement.querySelector("input[type=file]").click()
      }
  });

  const validation = () =>{
      if (document.getElementById("quotaFile").parentElement.parentElement.querySelector("input[type=file]").files.length == 0) {
            Common.alert("Kindly upload payslip in Attachment")
            return;
      }

      if (document.getElementById("quotaFile").parentElement.parentElement.querySelector("input[type=file]").files[0].type.substring(0,5) !="image") {
          Common.alert("Kindly upload image format only.")
          return;
      }

      if (document.getElementById("quotaFile").parentElement.parentElement.querySelector("input[type=file]").files[0].size > 2000000) {
          Common.alert("The file size of attachment file cannot upload over 2MB.")
          return;
      }

      return true;
}
  let myFileCaches = {};

  $("#btnConfirmPayment").click((e)=>{
      e.preventDefault();
      if(validation()){
          let file = document.getElementById("quotaFile").parentElement.parentElement.querySelector("input[type=file]").files[0];

          if(file == null && myFileCaches[0] != null){
              delete myFileCaches[0];
          }else if(file != null){
              myFileCaches[0] = {file:file};
          }

          const formData = new FormData();
          $.each(myFileCaches, function(n, v) {
              formData.append(n, v.file);
          });

          Common.ajaxFile("/sales/posstock/attachFileUpload.do", formData, function(result) {
	              if(result != 0 && result.code == 00){
	                  Common.showLoader();
	                  fetch("/sales/posstock/confirmPayment.do",{
	                      method : "POST",
	                      headers : {
	                          "Content-Type" : "application/json",
	                      },
	                      body : JSON.stringify({esnNo : esnNo, fileId : result.data.fileGroupKey})
	                  })
	                  .then( r=> r.json())
	                  .then(
	                          data => {
	                              Common.removeLoader()
	                              if(data.code =="00"){
	                            	  Common.alert("ESN Number is : " + data.data.esnNo, ()=>{location.reload();});
	                            	  return;
	                              }
	                              Common.alert("Fail to create order. Please check with System Administrator.", ()=>{location.reload();});
	                              return;
	                          }
	                   )
	              }
	              else{
	                   Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message, ()=>{location.reload();});
	                   return;
	              }
           },function(result){
                   Common.alert("Upload Failed. Please check with System Administrator.", ()=>{location.reload();});;
                   return;
           });
      }
  });

  const cancelPayment = () => {
	    Common.showLoader();
        fetch("/sales/posstock/deactivatePayment.do",{
            method : "POST",
            headers : {
                "Content-Type" : "application/json",
            },
            body : JSON.stringify({esnNo})
        })
        .then( r=> r.json())
        .then(
                data => {
                    Common.removeLoader()
                    console.log(data);
                    if(data.code == "00"){
                        Common.alert("This ESN Number : "+ esnNo + " has been cancelled", ()=>{location.reload();});
                        return;
                    }
                    Common.alert(data.message, ()=>{location.reload();}); return;
                }
    )};


 $("#btnCancelPayment").click((e)=>{
	    e.preventDefault();
	    cancelPayment();
 });

 $("#btnCloseStock").click((e)=>{
	    e.preventDefault();
	    fetch("/sales/posstock/checkValidationEsn?esnNo=" + esnNo)
	    .then(r=>r.json())
	    .then(data=>{
	    	if(data.checkFile == "0" && data.esnStatus =="44"){
	            cancelPayment();
	    	}
	    })
 });

</script>

