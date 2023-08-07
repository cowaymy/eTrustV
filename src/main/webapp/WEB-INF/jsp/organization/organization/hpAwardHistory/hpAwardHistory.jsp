<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<section id="content">
    <ul class="path"></ul>
    <aside class="title_line">
        <p class="fav"><a></a><h2>HP Award History</h2></p>
        <ul class="right_btns">
	        <li><p class="btn_blue" id="btnSearch"><a><span class="search"></span>Search</a></p></li>
	        <li><p class="btn_blue" id="btnClear"><a><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside>
        <form id="hpAwardHistoryForm">
        <table class="type1">
            <colgroup>
                <col style="width: 150px;"/>
                <col style="width: *;"/>
                <col style="width: 150px;"/>
                <col style="width: *;"/>
            </colgroup>
            <tbody>

	            <tr>
	                <th>Batch No</th>
	                <td><input class="w100p" type="text" name="batchNo" id="batchNo" /></td>

	                <th>Create Date</th>
	                <td>
	                    <div class="date_set w100p">
	                        <p><input name="start" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	                        <span>To</span>
	                        <p><input name="end" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	                    </div>
	                </td>
	            </tr>

	            <tr>
	                <th>Creator</th>
                    <td><input class="w100p" type="text" name="creator"></td>

                    <th>Batch Status</th>
                    <td>
                        <select class="w100p" name="hpAwardStus">
	                        <option value="">Choose One</option>
	                        <option value="120">Draft</option>
	                        <option value="121">Submitted</option>
	                        <option value="5">Approved</option>
	                        <option value="6">Rejected</option>
	                        <option value="10">Cancelled</option>
                        </select>
                    </td>
	            </tr>
            </tbody>
        </table>
    </form>

    <aside class="link_btns_wrap">
        <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
        <dl class="link_list">
            <dt>Link</dt>
            <dd>
                <ul class="btns">
	                <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
	                 <li><p class="link_btn"><a href="#" id="btnConfirm">Confirm Upload</a></p></li>
	                </c:if>
	                <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
	                <li><p class="link_btn"><a href="#" id="btnView">View Upload Batch</a></p></li>
	                </c:if>
	                <li><p class="link_btn"><a href="#" id="btnConfigure">Configure Incentive Code</a></p></li>
                </ul>
                <ul class="btns">
                    <li><p class="link_btn type2"><a id="btnUpload">New Upload</a></p></li>
                </ul>
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
            </dd>
        </dl>
    </aside>
    <br/>
    <div id="hpAwardGrid"></div>
</section>


<script>
  	const hpAwardGrid =  AUIGrid.create('hpAwardGrid',[
		  {
		   	  dataField : 'batchNo', headerText : 'Batch No'
		  },
          {
              dataField : 'batchStatus', headerText : 'Batch Status'
          },
          {
              dataField : 'total', headerText : 'Total'
          },
          {
              dataField : 'batchUploadDate', headerText : 'Batch Upload Date', dataType: "date", formatString: "dd-mm-yyyy",
          },
          {
              dataField : 'creator', headerText : 'Creator'
          },
          {
              dataField : 'approvalDate', headerText : 'Approval Date' , dataType: "date", formatString: "dd-mm-yyyy"
          },
          {
              dataField : 'approver', headerText : 'Approver'
          }
  	],'',
  	{
          usePaging: true,
          pageRowCount: 50,
          editable: false,
          showRowNumColumn: true,
          wordWrap: true,
          showStateColumn: false
  	});

  	const generateGrid = () =>{
  		Common.showLoader();
  	    fetch("/organization/selectHpAwardHistoryListing.do")
  	    .then(r=>r.json())
  	    .then(data => {
  	    	Common.removeLoader();
  	        AUIGrid.setGridData(hpAwardGrid, data);
  	    });
  	}

  	generateGrid();

    let status, checkedItem, batchNo;

    AUIGrid.bind(hpAwardGrid, "cellClick", (event) => {
          checkedItem = event.item;
          batchNo = checkedItem.batchNo
          status = checkedItem.batchStatus
     });

    $("#btnSearch").click((e)=>{
    	e.preventDefault();
    	Common.showLoader();
    	fetch("/organization/selectHpAwardHistoryListing.do?" + $("#hpAwardHistoryForm").serialize())
   	    .then(r=>r.json())
   	    .then(data => {
   	    	Common.removeLoader();
   	    	AUIGrid.setGridData(hpAwardGrid, data);
   	    });
    });

  	$("#btnUpload").click((e)=>{
  		e.preventDefault();
        Common.popupDiv("/organization/hpAwardHistoryNewUpload.do", null, null, true , null);
  	});

    $("#btnView").click((e)=>{
    	e.preventDefault();
        if(checkedItem){
        	let params ={ status , batchNo};
            Common.popupDiv("/organization/hpAwardHistoryDetails.do", params , null, true , null);
        }else{
        	Common.alert('Please choose the "Batch No" for proceed to view.')
        }
    });

    $("#btnConfigure").click((e)=>{
    	e.preventDefault();
    	Common.popupDiv("/organization/hpAwardHistoryConfigureIncentive.do", null, null, true , null);
    });

    $("#btnConfirm").click((e)=>{
    	e.preventDefault();
        if(checkedItem){
            let params ={ status , batchNo};
            Common.popupDiv("/organization/hpAwardHistoryConfirmDetails.do", params , null, true , null);
        }else{
            Common.alert('Please choose the "Batch No" for proceed to confirm.')
        }
    });

    $("#btnClear").click((e)=>{
    	e.preventDefault();
    	document.getElementById("hpAwardHistoryForm").reset();
    	generateGrid();
    });

    $("#batchNo").unbind().bind("change keyup", function(e) {
        $(this).val($(this).val().replace(/[\D]/g,"").trim());
    });

</script>
