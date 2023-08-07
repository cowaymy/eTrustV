<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>
.my-pink-style {
    background:#FFA7A7;
    font-weight:bold;
    color:#22741C;
    height:25px
}
.height-style{
    height:25px
}
</style>

<div class="popup_wrap" id="popup_wrap3">
    <header class="pop_header">
        <h1 id="confirmDetailsHeader"></h1>
        <ul class="right_opt">
          <li><p class="btn_blue2"><a>CLOSE</a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <table class="type1">
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                        <th scope="row">Status</th>
                        <td><input type="text"  class="w100p" id="confirmDetailsStatus" disabled></td>

                        <th scope="row">Update By</th>
                        <td><input type="text"  class="w100p" id="confirmDetailsUpdator" disabled></td>
                </tr>

                <tr>
                        <th scope="row">Total Item</th>
                        <td><input type="text"  class="w100p" id="confirmDetailsTotal" disabled></td>

                        <th></th>
                        <td></td>
                </tr>
            </tbody>
        </table>
        <br/>
        <article class="grid_wrap">
                <div id="hpAwardVerifyGrid" style="width:100%; height:400px; margin:0 auto;"></div>
                <br/>
                <ul class="center_btns">
                     <li><p class="btn_blue2 big"><a id="btnApprove">Approve</a></p></li>
                     <li><p class="btn_blue2 big"><a id="btnReject">Reject</a></p></li>
                     <li><p class="btn_blue2 big"><a id="btnDeactivateSubmitted">Deactivate</a></p></li>
                </ul>
        </article>
 </section>
</div>

<script>

     let verifyData = ${verifyData};

     if(verifyData){
         $("#confirmDetailsStatus").val(verifyData[0].status);
         $("#confirmDetailsUpdator").val(verifyData[0].updator + ' ' + verifyData[0].updDt);
     }

     document.querySelector("#confirmDetailsHeader").innerHTML = `HP Award History - Confirmation ( Batch No : ` +verifyData[0].batchId + `)`;

     const hpAwardVerifyGrid =  GridCommon.createAUIGrid('hpAwardVerifyGrid',[
	      {
	          dataField : 'batchId', headerText : 'Batch No', editable : false, visible: false
	      },
	      {
	          dataField : 'stusCodeId', headerText : 'Status', editable : false, visible: false
	      },
	      {
	          dataField : 'hpCode', headerText : 'HP Code'
	      },
	      {
	          dataField : 'month', headerText : 'Month'
	      },
	      {
	          dataField : 'year', headerText : 'Year'
	      },
	      {
	          dataField : 'incentiveCode', headerText : 'Incentive Code', width: '30%'
	      },
	      {
	          dataField : 'description', headerText : 'Description', width: '30%'
	      },
	      {
	          dataField : 'destination', headerText : 'Destination', width: '30%'
	      },
	      {
	          dataField : 'remark', headerText : 'Remark', width: '30%'
	      }
		],'',
		{
		      usePaging: true,
		      pageRowCount: 20,
		      showRowNumColumn: true,
		      wordWrap: true,
		      showStateColumn: false,
		      editable : false,
		      showRowCheckColumn : false,
		      rowStyleFunction: (i, item) => {
		    	  if(item.stusCodeId == 8) return "my-pink-style"
		    	  else return "height-style";
		      }
		});

       AUIGrid.setGridData(hpAwardVerifyGrid, verifyData[0].details.map(e => ({...e, btnText: e.stusCodeId == 8 ? "Unremove" : "Remove"})));

       const recalculateItem = () => {
           $("#confirmDetailsTotal").val(AUIGrid.getGridData(hpAwardVerifyGrid).length);
       }

       recalculateItem();

       if(verifyData[0].status != "Submitted"){
    	    $("#btnApprove").hide();
    	    $("#btnReject").hide();
       }else{
           $("#btnApprove").show();
           $("#btnReject").show();
       }

       $("#btnApprove").click((e)=>{
           e.preventDefault();

           if(!AUIGrid.getGridData(hpAwardVerifyGrid).every((e)=> {
                if(!e.description?.trim().length) return false;
                return true;
	       })){
	           Common.alert("Description cannot have empty value. <br/> Please proceed to configure Incentive Code for proceed to approval stage.");
	           return;
	       }

           Common.alert("Are you confirm to confirm Batch No : " + verifyData[0].batchId + "?", ()=>{
        	   Common.showLoader();
        	   fetch("/organization/updateHpAwardHistoryStatus.do",{
                   method : "POST",
                   headers : {"Content-Type" : "application/json"},
                   body :JSON.stringify({batchId : verifyData[0].batchId, type: "approve", status : 5 })
               })
               .then(r=>r.json())
               .then(response => {
            	   Common.removeLoader();
                   Common.alert(response.msg , response.success==1 ? ()=>{location.reload()} : '');
               })
           });
       });

       $("#btnReject").click((e)=>{
           e.preventDefault();
           Common.alert("Are you confirm to reject Batch No : " + verifyData[0].batchId + "?", ()=>{
        	   Common.showLoader();
        	   fetch("/organization/updateHpAwardHistoryStatus.do",{
                   method : "POST",
                   headers : {"Content-Type" : "application/json"},
                   body :JSON.stringify({batchId : verifyData[0].batchId, type: "reject", status : 6 })
               })
               .then(r=>r.json())
               .then(response => {
            	   Common.removeLoader();
                   Common.alert(response.msg , response.success==1 ? ()=>{location.reload()} : '');
               })
           });
       });

       $("#btnDeactivateSubmitted").click((e)=>{
           e.preventDefault();
           Common.alert("Are you confirm to deactivate Batch No : " + verifyData[0].batchId + "?", ()=>{
               Common.showLoader();
               fetch("/organization/updateHpAwardHistoryStatus.do",{
                   method : "POST",
                   headers : {"Content-Type" : "application/json"},
                   body :JSON.stringify({batchId : verifyData[0].batchId, type: "deactivate", status : 10 })
               })
               .then(r=>r.json())
               .then(response => {
                   Common.removeLoader();
                   Common.alert(response.msg , response.success==1 ? ()=>{location.reload()} : '');
               })
           });
       });


   </script>