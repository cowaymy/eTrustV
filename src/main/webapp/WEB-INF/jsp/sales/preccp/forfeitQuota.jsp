<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<div class="popup_wrap">
    <header class="pop_header">
        <h1>Forfeit Monthly Data</h1>
        <ul class="right_opt">
          <li><p class="btn_blue2"><a href="#" id="close">CLOSE</a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <p style="color: #25527c; padding-left: 5px;" id="forfeitBatchNo"></p><br/>
        <form method="post" id="forfeitForm">
            <input type="hidden" value="${batchId}">
            <div style="height:80%;background:#25527c;">
	            <div style="padding:20px;font-size:14px;color: white;text-align:center;line-height:2;">
		            If you click on "Forfeit this batch", the quota will be permanently deleted.
	                The Organization wont'be able to use Pre-CCP until CCP refreshes a new quota.
	                To refresh a quota, you need to upload a new file. <br/><br/>
	                Are you certain you want to forfeit this batch number?
	            </div>
            </div>
            <br/>
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Forfeit Reason</th>
                        <td colspan=3>
                            <textarea cols="20" name="forfeitRsn" id="forfeitRsn" rows="5"></textarea>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
        <ul class="center_btns mt20">
            <li><p class="btn_blue2 big"><a id="btnForfeit">Forfeit this batch</a></p></li>
            <li><p class="btn_blue2 big"><a id="btnCancel">Cancel</a></p></li>
        </ul>
 </section>
</div>

<script>

    document.getElementById("forfeitBatchNo").innerHTML = "Forfeit Batch Upload ${batchId}";

	const forfeitChecking = () => {
		if(!$("#forfeitRsn").val()?.trim()){
			Common.alert("Please include a comment before saving. It is required.");
			return false;
		}
		return true;
	}


	$("#btnForfeit").click((e)=>{
		 e.preventDefault();
		 if(forfeitChecking()){
		    fetch("/sales/ccp/confirmForfeit.do",{
	             method : "POST",
	             headers : {
	                 "Content-Type" : "application/json",
	             },
	             body : JSON.stringify({batchId: ${batchId}, forfeitRsn: $("#forfeitRsn").val()})
	         })
		    .then((r)=> {
                if(r.status == 500){
                    Common.removeLoader();
                    Common.alert("Forfeit failed! \n Kindly raise ticket with corresponding details.");
                }else{
                    return r.json();
                }
		    })
		    .then(data=>{
		        Common.alert(data.message,(()=>location.reload()));
		    });
		 }
	});

    $("#btnCancel").click((e)=>{
	      e.preventDefault();
	      $("#close").click();
	});



</script>