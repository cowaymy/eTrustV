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


<div class="popup_wrap" id="popup_wrap4">
    <header class="pop_header">
        <h1>Configuration for Incentive Code</h1>
        <ul class="right_opt">
          <li><p class="btn_blue2"><a id="btnCloseView">CLOSE</a></p></li>
        </ul>
    </header>

    <section class="pop_body">

        <aside class="title_line">
              <ul class="right_btns">
                    <li><p class="btn_grid"><a id="btnAddIncentive">Add</a></p></li>
               </ul>
        </aside>

        <article class="grid_wrap">
                <div id="incentiveGrid" style="width:100%; height:400px; margin:0 auto;"></div>
                <br/>
                <ul class="center_btns">
                     <li><p class="btn_blue2 big"><a id="btnSave">Save</a></p></li>
                </ul>
        </article>
    </section>
</div>


<script type="text/javascript">

    const incentiveGrid =  GridCommon.createAUIGrid('incentiveGrid',[
       {
           dataField: "btnText",
           headerText : 'Action',
           editable: false,
           width: '20%',
           renderer: {
               type: "ButtonRenderer",
               onclick : function(rowIndex, columnIndex, value, item) {
            	           AUIGrid.setCellValue(incentiveGrid, rowIndex, "stusCodeId", 8);
            	           AUIGrid.removeRow(incentiveGrid, rowIndex);
               },
           }
       },
       {
           dataField : 'stusCodeId', headerText : 'Status', editable : false, visible: false
       },
       {
           dataField : 'incentiveCode', headerText : 'Incentive Code', width: '40%'
       },
       {
           dataField : 'incentiveDescription', headerText : 'Incentive Description', width: '50%'
       },
       ],'',
		 {
		       usePaging: true,
		       pageRowCount: 20,
		       showRowNumColumn: true,
		       wordWrap: true,
		       showStateColumn: false,
		       editable : true,
		       softRemoveRowMode:false,
		       showRowCheckColumn : false,
		       rowStyleFunction: (i, item) => {
		          return "height-style";
		       }
    });

    fetch("/organization/selectIncentiveCode.do")
    .then(r=>r.json())
    .then(data => {
    	 AUIGrid.setGridData(incentiveGrid, data.map(e => ({...e, btnText: e.stusCodeId == 8 ? "Unremove" : "Remove"})));
    });

    $("#btnAddIncentive").click((e) =>{
        e.preventDefault();
        let item = new Object();
        item.detailId = 0;
        item.btnText = "Remove";
        item.stusCodeId =1;
        AUIGrid.addRow(incentiveGrid, item , "first");
    });

    document.getElementById("btnRemoveIncentive") && (document.getElementById("btnRemoveIncentive").onclick = () => {
        AUIGrid.removeRow(incentiveGrid, "selectedIndex")
    })

    $("#btnSave").click((e)=>{
        e.preventDefault();

        if(!AUIGrid.getGridData(incentiveGrid).every((e)=> {
            if(!e.incentiveCode?.trim().length) return false;
            if(!e.incentiveDescription?.trim().length) return false;
            return true;
        })){
            Common.alert("Please fill in data completely before submit data.");
            return;
        }

        let addList = AUIGrid.getAddedRowItems(incentiveGrid);
        let editList = AUIGrid.getEditedRowItems(incentiveGrid);
        let removeList = AUIGrid.getRemovedItems(incentiveGrid);

        if (addList.length == 0 && editList.length == 0 && removeList.length ==0) {
            Common.alert("<spring:message code='sys.common.alert.noChange'/>");
            return false;
        }

        let params = {addList, editList, removeList};

        Common.showLoader();
        fetch("/organization/updateIncentiveCode.do",{
            method: "POST",
            headers : {
                "Content-Type" : "application/json",
            },
            body: JSON.stringify(params)
        })
        .then(d=>d.json())
        .then(data => {
            Common.removeLoader();
            if(data.success == -1){
            	Common.alert("Kindly please copy below error msg and proceed to raise ticket to IT Dept for checking. <br/><br/>" + data.msg, ()=>{location.reload()});
                return;
            }
            Common.alert(data.msg, data.success>0 ? ()=>{location.reload()} : "");
        });
    });

</script>
