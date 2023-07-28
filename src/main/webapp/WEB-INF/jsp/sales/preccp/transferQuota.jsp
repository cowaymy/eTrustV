<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>
	.height-style{
	    height:25px
	}

	.headerStyle{
	    color: #25527c;
	    line-height:2;
	}
</style>

<div class="popup_wrap" id="popup_wrap2">
    <header class="pop_header">
        <h1>Transfer Quota</h1>
        <ul class="right_opt">
          <li><p class="btn_blue2"><a id="btnCloseView">CLOSE</a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <div>
            <h4 class="headerStyle">Important:</h4>
            <p  class="headerStyle">1. You are permitted to transfer your quota within your organization groups.</p>
            <p  class="headerStyle">2. You have the option to transfer a minimum of 10 quotas to any group listed below.</p>
        </div>

        <article class="grid_wrap">
                <div id="transferGrid" style="width:100%; height:400px; margin:0 auto;"></div>
                <br/>
                <ul class="center_btns">
                     <li><p class="btn_blue2 big"><a id="btnSave">Save</a></p></li>
                </ul>
        </article>
 </section>
</div>

<script>

    let orgLvlList = ${orgLvlList};

	const transferGrid =  GridCommon.createAUIGrid('transferGrid',[
	 {
	     dataField : 'orgCode', headerText : 'Org Code', width: "15%", editable: false
	 },
	 {
	     dataField : 'grpCode', headerText : 'Group Code', width: "15%", editable: false
	 },
	 {
	     dataField : 'name', headerText : 'Name', width: "40%", editable: false
	 },
	 {
	     dataField : 'transferQuota', headerText : 'Transfer Quota', width: "35%", editable: true
	 }],'',
	{
	     usePaging: true,
	     pageRowCount: 50,

	     showRowNumColumn: true,
	     wordWrap: true,
	     showStateColumn: false,
         rowStyleFunction: (i, item) => { return "height-style";}
	});

	AUIGrid.setGridData(transferGrid, orgLvlList);

	$("#btnSave").click((e)=>{
		e.preventDefault();
	    let editList = AUIGrid.getEditedRowItems(transferGrid);

       if (editList.length == 0) {
              Common.alert("<spring:message code='sys.common.alert.noChange'/>");
              return false;
       }

	   if(!editList.every((e)=> {
	           if(isNaN(e.transferQuota)) return false;
	       return true;
	    })){
	       Common.alert("Please fill in Transfer Quota in number format.");
	       return;
	    }

	   editList = editList.filter(e =>{
		   if(e.transferQuota.trim()){
			   return true;
		   }
	   });

	   if(editList){
           Common.showLoader();
           let orgCode = "${requestFrom.orgCode}";
           let grpCode = "${requestFrom.grpCode}";
           let year = "${requestFrom.year}";
           let month = "${requestFrom.month}";
           console.log("${requestFrom}");
           let params = {orgCode, grpCode ,year, month, editList};
           fetch("/sales/ccp/updateTransferQuota.do",{
               method : "POST",
               headers : {"Content-Type" : "application/json"},
               body : JSON.stringify(params)
           })
           .then(r=>r.json())
           .then(response => {
               Common.removeLoader();
               Common.alert(response.message,()=>{location.reload()});
           })
	   }

	});


</script>