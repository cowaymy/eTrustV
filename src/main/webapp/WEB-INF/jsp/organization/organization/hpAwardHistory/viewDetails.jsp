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

<div class="popup_wrap" id="popup_wrap2">
    <header class="pop_header">
        <h1 id="detailsHeader"></h1>
        <ul class="right_opt">
          <li><p class="btn_blue2"><a id="btnCloseView">CLOSE</a></p></li>
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
			            <td><input type="text"  class="w100p" id="viewStatus" disabled></td>

			            <th scope="row">Update By</th>
                        <td><input type="text"  class="w100p" id="viewUpdator" disabled></td>
			    </tr>

			    <tr>
                        <th scope="row">Total Item</th>
                        <td><input type="text"  class="w100p" id="viewTotal" disabled></td>

                        <th></th>
                        <td></td>
                </tr>
		    </tbody>
		</table>

		<aside class="title_line">
		      <ul class="right_btns">
                    <li><p class="btn_grid"><a id="btnAddDetails">Add Item</a></p></li>
                    <li><p class="btn_grid"><a id="btnRemoveDetails">Remove Item</a></p></li>
                    <li><p class="btn_grid"><a id="btnUnremoveDetails">Unremove Item</a></p></li>
               </ul>
		</aside>

		<article class="grid_wrap">
                <div id="hpAwardViewGrid" style="width:100%; height:400px; margin:0 auto;"></div>
                <br/>
		        <ul class="center_btns">
		             <li><p class="btn_blue2 big"><a id="btnDraft">Save as Draft</a></p></li>
			         <li><p class="btn_blue2 big"><a id="btnSubmit">Submit</a></p></li>
			         <li><p class="btn_blue2 big"><a id="btnDeactivate">Deactivate</a></p></li>
			    </ul>
		</article>
 </section>
</div>

<script>

    let request = ${viewData};

    document.querySelector("#detailsHeader").innerHTML = `HP Award History - View ( Batch No : ` +request[0].batchId + `)`;

    if(request){
    	$("#viewStatus").val(request[0].status);
    	$("#viewUpdator").val(request[0].updator + ' ' + request[0].updDt);

        if(request[0].status == "Draft"){
            $("#btnDraft").show();
            $("#btnSubmit").show();
            $("#btnDeactivate").show();

            $("#btnAddDetails").show();
            $("#btnRemoveDetails").show();
            $("#btnUnremoveDetails").show();

        }else if(request[0].status == "Submitted"){
            $("#btnDraft").hide();
            $("#btnSubmit").hide();
            $("#btnDeactivate").show();

            $("#btnAddDetails").hide();
            $("#btnRemoveDetails").hide();
            $("#btnUnremoveDetails").hide();
        }else{
            $("#btnDraft").hide();
            $("#btnSubmit").hide();
            $("#btnDeactivate").hide();

            $("#btnAddDetails").hide();
            $("#btnRemoveDetails").hide();
            $("#btnUnremoveDetails").hide();
        }
    }

   const hpAwardViewGrid =  GridCommon.createAUIGrid('hpAwardViewGrid',[
          {
        	  dataField: "btnText",
              headerText : 'Action',
           	  editable: false,
           	  width: '15%',
              renderer: {
            	  type: "ButtonRenderer",
            	  onclick : function(rowIndex, columnIndex, value, item) {
                          AUIGrid.setCellValue(hpAwardViewGrid, rowIndex, "stusCodeId", item.stusCodeId==1? 8 :1);
                          AUIGrid.setCellValue(hpAwardViewGrid, rowIndex, "btnText", item.stusCodeId==1? "Remove" : "Unremove");
                          recalculate();
            	  },
              }
          },
          {
              dataField : 'batchId', headerText : 'Batch No', editable : false, visible: false
          },
          {
              dataField : 'stusCodeId', headerText : 'Status', editable : false, visible: false
          },
          {
              dataField : 'hpCode', headerText : 'HP Code',  editable : request[0].status=="Draft" ? true : false
          },
          {
              dataField : 'month', headerText : 'Month',  editable : request[0].status=="Draft" ? true : false
          },
          {
              dataField : 'year', headerText : 'Year',  editable : request[0].status=="Draft" ? true : false
          },
          {
              dataField : 'incentiveCode', headerText : 'Incentive Code', width: '20%', editable : request[0].status=="Draft" ? true : false
          },
          {
              dataField : 'description', headerText : 'Description', width: '20%', editable : false, visible: false
          },
          {
              dataField : 'destination', headerText : 'Destination', width: '20%', editable : request[0].status=="Draft" ? true : false
          },
          {
              dataField : 'remark', headerText : 'Remark', width: '20%', editable : request[0].status=="Draft" ? true : false
          }
    ],'',
    {
          usePaging: true,
          pageRowCount: 20,
          showRowNumColumn: true,
          wordWrap: true,
          showStateColumn: false,
          showRowCheckColumn : request[0].status=="Draft" ? true :false,
          rowStyleFunction: (i, item) => {
        	  if(item.stusCodeId == 8) return "my-pink-style"
              else return "height-style";
          }
    });

   if(!(request[0].details.length == 1  && request[0].details[0].detailId == 0)){
	   AUIGrid.setGridData(hpAwardViewGrid, request[0].details.map(e => ({...e, btnText: e.stusCodeId == 8 ? "Unremove" : "Remove"})));
   }

   const recalculate = () => {
	   $("#viewTotal").val(AUIGrid.getGridData(hpAwardViewGrid).length);
   }

   recalculate();

   $("#btnRemoveDetails").click((e) =>{
	   e.preventDefault();
	   let checkDetails = AUIGrid.getCheckedRowItemsAll(hpAwardViewGrid);
	   if(checkDetails.length){
		   checkDetails = checkDetails.map(e => {
			   if(e.stusCodeId)  {
				   return {...e, stusCodeId: 8, btnText: "Unremove"}
			   }
			   return e;
		   });
		   AUIGrid.updateRowsById(hpAwardViewGrid, checkDetails);
		   recalculate();
	   }
   });

   $("#btnUnremoveDetails").click((e) =>{
       e.preventDefault();
       let checkDetails = AUIGrid.getCheckedRowItemsAll(hpAwardViewGrid);
       if(checkDetails.length){
           checkDetails = checkDetails.map(e => {
               if(e.stusCodeId)  {
                   return {...e, stusCodeId: 1, btnText: "Remove"}
               }
               return e;
           });
           AUIGrid.updateRowsById(hpAwardViewGrid, checkDetails);
           recalculate();
       }
   });

   $("#btnAddDetails").click((e) =>{
		 e.preventDefault();
		 let item = new Object();
	     item.batchId = request[0].batchId;
	     item.detailId = 0;
		 item.btnText = "Remove";
		 item.stusCodeId =1;
		 AUIGrid.addRow(hpAwardViewGrid, item , "first");
		 recalculate();
   });

   $("#btnDeactivate").click((e)=>{
       e.preventDefault();
	   Common.alert("Are you confirm to deactivate Batch No : " + request[0].batchId + "?", ()=>{
		   Common.showLoader();
		   fetch("/organization/updateHpAwardHistoryStatus.do",{
			   method : "POST",
			   headers : {"Content-Type" : "application/json"},
			   body :JSON.stringify({batchId : request[0].batchId, type: "deactivate", status : 10 })
		   })
		   .then(r=>r.json())
		   .then(response => {
			   Common.removeLoader();
			   Common.alert(response.msg , response.success==1 ? ()=>{location.reload()} : '');
		   })
	   });
   });

   const saveData = (msgSuccess, msgFailed, status) => {
       let addList = AUIGrid.getAddedRowItems(hpAwardViewGrid);
       let editList = AUIGrid.getEditedRowItems(hpAwardViewGrid);
       let batchId = request[0].batchId;
       let params = {addList, editList, status, batchId};

       fetch("/organization/updateHpAwardHistoryDetails.do",{
           method: "POST",
           headers : {
               "Content-Type" : "application/json",
           },
           body: JSON.stringify(params)
       })
       .then(d=>d.json())
       .then(data => {
    	   Common.removeLoader();
           Common.alert(data.success==1 ? msgSuccess : msgFailed, ()=>{location.reload()});
       });
   }

   $("#btnSubmit").click((e)=>{
	   e.preventDefault();

       if(!AUIGrid.getGridData(hpAwardViewGrid).every((e)=> {
               if(!e.hpCode?.trim().length) return false;
    	       if(isNaN(e.month)) return false;
    	       if(isNaN(e.year)) return false;
	           if(!e.incentiveCode?.trim().length) return false;
	           if(!e.destination?.trim().length) return false;
	           if(!e.remark?.trim().length) return false;
           return true;
       })){
           Common.alert("Please fill in correct data completely before submit data.");
           return;
       }

       Common.showLoader();
       saveData("Sucess to submit.", "Fail to submit.", 121);
   });

   $("#btnDraft").click((e) => {
       e.preventDefault();

       if (AUIGrid.getAddedRowItems(hpAwardViewGrid).length == 0 && AUIGrid.getEditedRowItems(hpAwardViewGrid).length == 0) {
              Common.alert("<spring:message code='sys.common.alert.noChange'/>");
              return false;
       }

       if(!AUIGrid.getGridData(hpAwardViewGrid).length){
           Common.alert("Cannot save with empty records.");
           return false;
       }

       if(!AUIGrid.getGridData(hpAwardViewGrid).every((e)=> {
	           if(isNaN(e.month)) return false;
	           if(isNaN(e.year)) return false;
	       return true;
	    })){
	       Common.alert("Please fill in Month / Year in number format.");
	       return;
	    }
        Common.showLoader();
        saveData("Success to save as draft.", "Fail to save as draft.", 120);
   });

</script>