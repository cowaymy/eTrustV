<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<style type="text/css">
	.aui-grid-user-custom-left {
	    text-align:left;
	}

	.aui-grid-user-custom-right {
	    text-align:right;
	}
</style>

<div id="popup_wrap" class="popup_wrap">

	<header class="pop_header">
		<h1>Stock</h1>
		<ul class="right_opt"><li><p class="btn_blue2"><a id="btnCloseStock">CLOSE</a></p></li></ul>
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
		          <th colspan="1">Branch / Warehouse</th>
		          <td colspan="3"><select class="w100p checkStock" name="stockBranch" id="stockBranch"></select></td>
		     </tr>

		     <tr>
			       <th scope="row">Selling Type</th>
			       <td><select class="w100p checkStock" id="stockType"  name="stockType"></select></td>

			       <th scope="row">Item Type</th>
			       <td><input type="text" class="w100p readonly"  id="stockItemType"  name="stockItemType" value="Item Bank" readonly="readonly"/></td>
		     </tr>

		     <tr>
		           <th scope="row">Category</th>
		           <td>
		                <select class="w100p checkStock" id="stockCategory" name="stockCategory">
		                    <option value="">Choose One</option>
		                    <option value="1346">Merchandise Item</option>
		                    <option value="1348">Misc Item</option>
		                    <option value="1347">Uniform</option>
		                </select>
		           </td>

				   <th scope="row">Item</th>
		           <td><select class="w100p checkStock" id="stockItem" name="stockItem"></select></td>
		      </tr>
		    </tbody>
		</table>
	</form>

	<ul class="right_btns" style="display: flex;justify-content: space-between;align-items: center;">
		 <div>Stock Availability</div>
	     <div>
		        <li><p class="btn_grid"><a id="btnSearchStock">Search</a></p></li>
		        <li><p class="btn_grid"><a id="btnClearStock">Clear</a></p></li>
	     </div>
    </ul>

    <article class="grid_wrap">
            <div id="stockGrid" style="width:100%; height:300px; margin:0 auto;"></div>
            <div id="stockGridExcel" style="height:430px;display:none;"></div>
    </article>

    <ul class="center_btns">
		    <li><p class="btn_blue2 big"><a id="btnGenerateExcel">Generate Excel</a></p></li>
		    <li><p class="btn_blue2 big"><a id="btnCancelStock">Cancel</a></p></li>
    </ul>
    </section>
</div>

<script>

const branch = document.getElementById("stockBranch"), stockType = document.getElementById("stockType");

const getBranch = () =>{
	branch.innerHTML = "";
	branch.innerHTML += "<option value=''>Choose One</option>";
    fetch("/sales/pos/selectWhSOBrnchList?code=SO")
    .then(r=>r.json())
    .then(data=>{
        for(let i = 0; i < data.length; i++) {
            const {codeName, codeId} = data[i]
            branch.innerHTML += "<option value='" + codeId + "'>" + codeName + "</option>"
        }
    })
}

const getStockType = () =>{
	stockType.innerHTML = "";
	stockType.innerHTML += "<option value=''>Choose One</option>";
    fetch("/sales/pos/selectPosModuleCodeList?groupCode=507&codeIn%5B%5D=6796&codeIn%5B%5D=6797")
    .then(r=>r.json())
    .then(data=>{
        for(let i = 0; i < data.length; i++) {
            const {codeName, codeId} = data[i]
            stockType.innerHTML += "<option value='" + codeId + "'>" + codeName + "</option>"
        }
    })
}

const categoryChange = () =>{
    CommonCombo.make('stockItem', "/sales/pos/selectPosItmList", {itemType : $("#stockCategory").val() , posItm : 1} , '', {type: "S", isCheckAll: false});
}

$("#stockCategory").change((e)=>{
	categoryChange();
});

categoryChange();
getBranch();
getStockType();


const stockGrid =   GridCommon.createAUIGrid('stockGrid',[
   {
          dataField : 'warehouse', headerText : 'Branch / Warehouse', width: '40%'
   },
   {
          dataField : 'itemFullDesc', headerText : 'Item Description', width: '40%'
   },
   {
          dataField : 'stockBal', headerText : 'Stock Balance'
   }],'',
   {
          usePaging: true,
          pageRowCount: 20,
          editable: false,
          showRowNumColumn: true,
          wordWrap: true,
          showStateColumn: false,
   });

const stockGridExcel =   GridCommon.createAUIGrid('stockGridExcel',[
	{
	       dataField : 'warehouse', headerText : 'Branch / Warehouse', width: 300
	},
	{
           dataField : 'sellingType', headerText : 'Selling Type', width: 150
    },
    {
           dataField : 'itemCode', headerText : 'Item Code', width: 150
    },
	{
	       dataField : 'itemFullDesc', headerText : 'Item Description', width: 300
	},
	{
	       dataField : 'stockBal', headerText : 'Stock Balance', width: 150
	}],'',
	{
		    selectionMode : "multipleCells",
		    showRowNumColumn : true,
		    showRowCheckColumn : false,
		    showStateColumn : true,
		    enableColumnResize : false,
		    enableMovingColumn : false
	});

const generateStockResult = () => {
    Common.showLoader();
    fetch("/sales/posstock/selectEshopStockList.do?" + $("#stockForm").serialize())
    .then(resp => resp.json())
    .then(data => {
        Common.removeLoader();
        data = data.map(i=>{
            return {...i}
        });
        AUIGrid.setGridData(stockGrid, data);
        AUIGrid.setGridData(stockGridExcel, data);
    });
}

$("#btnSearchStock").click((e)=>{
    e.preventDefault();
    let check = [...document.querySelectorAll(".checkStock")].some(r=> {
        if(r.value.trim().length){
            return true
         }
    });

    if(check){
        generateStockResult();
    }else{
        Common.alert("Please fill in one of searching criteria.")
    }
});

const clearForm = (formId) => {
    document.getElementById(formId).reset();
}

const genereteExcel = () =>{
    GridCommon.exportTo("stockGridExcel", "xlsx", "E-Shop Stock Availability Data_" + moment().format('YYYYMMDD'));
}

$("#btnClearStock").click((e)=> {
    e.preventDefault();
    clearForm("stockForm");
    AUIGrid.clearGridData(stockGrid);
});

$("#btnGenerateExcel").click((e)=> {
    e.preventDefault();
    genereteExcel();
});

$("#btnCancelStock").click((e)=> {
    e.preventDefault();
    $("#btnCloseStock").click();
});





</script>