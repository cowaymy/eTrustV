<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<style>
    .hidden {
        display: none !important;
    }

    .show {
        display: block !important;
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

    .popup_wrap.eprpop {
        width: 90% !important;
        left: 42%;
    }
</style>

<div id="popup_wrap" class="popup_wrap eprpop">
    <header class="pop_header">
        <h1>ePR Overview</h1>
        <ul class="right_opt">
          <c:if test="${editable}">
            <li><p class="btn_blue2"><a href="#" id="editEPR">EDIT</a></p></li>
          </c:if>
	      <li><p class="btn_blue2 hidden"><a href="#" id="btnCancelEPRPop">Cancel PR</a></p></li>
          <li><p class="btn_blue2"><a href="#" id="btnGuarViewClose">CLOSE</a></p></li>
        </ul>
    </header>
    <section class="pop_body">
        <c:if test="${openDecision}">
	        <ul class="right_opt">
	          <li><p class="btn_blue2" style="display: flex; justify-content: flex-end;"><a href="#" id="approvalPop">Decision</a></p></li>
	        </ul>
        </c:if>
        <ul class="tap_type1 num4">
            <li><a href="#" onClick="javascript:chgTab('info');">Basic Info</a></li>
            <li><a href="#" onClick="javascript:chgTab('distribute');">Distribution List</a></li>
        </ul>
        <article class="tap_area" id="ePRInfo">
            <table class="type1">
                <colgroup>
                    <col style="width: 130px;"/>
                    <col style="width: *;"/>
                    <col style="width: 130px;"/>
                    <col style="width: *;"/>
                </colgroup>
                <tr>
                    <th>Title</th>
                    <td colspan="3" class="ePRTitle"></td>
                </tr>
                <tr>
                    <th>Key in date</th>
                    <td class="ePRKeyin"></td>
                    <th>Creator User ID</th>
                    <td id="ePRUsr"></td>
                </tr>
                <tr>
                    <th>Cost Centre Code</th>
                    <td id="costCentreCode"></td>
                    <th>Cost Centre Name</th>
                    <td id="costCentreName"></td>
                </tr>
                <tr>
                    <th>ePR Status</th>
                    <td id="ePRStus"></td>
                    <th>ePR No</th>
                    <td id="ePRNo"></td>
                </tr>
                <tr>
                    <th>Approve Status</th>
                    <td id="ePRApproval" colspan="3"></td>
                </tr>
                <tr>
                    <th>Reject</th>
                    <td colspan="3" id="ePRReject"></td>
                </tr>
                <tr>
                    <th>Final Approver</th>
                    <td id="ePRFinal"></td>
                    <th>Assignment</th>
                    <td class="ePRAssign"></td>
                </tr>
            </table>
            <article class="acodi_wrap">
                <div>
                    <dt id="ePRAddInfo" class="click_add_on"><a href="#">Additional info</a></dt>
                    <dd data-caro="ePRAddInfo">
                        <table class="type1">
                            <colgroup>
			                    <col style="width: 130px;"/>
			                    <col style="width: *;"/>
			                </colgroup>
			                <tr>
			                    <th>Purpose / Remark</th>
			                    <td id="ePRRemark"></td>
			                </tr>
			                <tr>
                                <th>Receiver Information</th>
                                <td id="ePRRciv"><button></button></td>
                            </tr>
                            <tr>
                                <th>Attachment</th>
                                <td id="ePRAdd"><button></button></td>
                            </tr>
                        </table>
                    </dd>
                    <dt id="approvalOpinion"  class="click_add_on"><a href="#">Approval Opinion</a></dt>
                    <dd data-caro="approvalOpinion">
                        <div id="ePRApprovalGrid"></div>
                    </dd>
                </div>
            </article>
            <div id="itemGrid"></div>
        </article>
        <article class="tap_area hidden" id="ePRDistribute">
            <div id="ePRDistributeGrid"></div>
        </aritcle>
    </section>
</div>

<div id="popup_wrap" class="popup_wrap hidden">
    <header class="pop_header">
        <h1>ePR Edit</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="ePREditSubmit">Submit</a></p></li>
            <li><p class="btn_blue2"><a href="#" id="ePREditClose">Close</a></p></li>
        </ul>
    </header>
    <section class="pop_body">
	    <table class="type1">
            <colgroup>
                <col style="width: 130px;"/>
                <col style="width: *;"/>
                <col style="width: 130px;"/>
                <col style="width: *;"/>
            </colgroup>
            <tr>
               <th>EDIT Type</th>
               <td colspan="3">
                   <select id="ePREditType">
                       <option value=0>Assignment</option>
                       <option value=1>Distribution Update</option>
                   </select>
               </td>
            </tr>
            <tr>
                <th>Title</th>
                <td colspan="3" class="ePRTitle"></td>
            </tr>
            <tr>
                <th>ePR No</th>
                <td id="ePRNo"></td>
                <th>Key in date</th>
                <td class="ePRKeyin"></td>
            </tr>
            <tr id="ePREditAssign">
                <th>Assignment From</th>
                <td class="ePRAssign"></td>
                <th>Assignment To</th>
                <td>
                    <form>
                        <select name="assignMemId">
                            <c:forEach items="${spcMembers}" var="p">
                                <option value="${p.memId}">${p.userName}</option>
                            </c:forEach>
                        </select>
                        <textarea name="remark"></textarea>
                    </form>
                </td>
            </tr>
            <tr id="ePREditDistribute" class="hidden">
                <th>Distribution List</th>
                <td colspan="3">
                    <form>
                        <input type="text" readonly class="readonly"/>
                        <div id="ePRRcivFileInput" class="auto_file4" style="width: auto;"><!-- auto_file start -->
	                       <input type="file" title="file add" accept=".xlsx" />
	                       <label for="ePRRcivFileInput">
	                           <input id="ePRRcivFile" type="text" class="input_text" readonly class="readonly" placeholder="Only .xlsx file">
	                           <span class="label_text2"><a href="#">File</a></span>
	                       </label>
	                       <span class="label_text2"><a id="example_download">Download CSV File</a></span>
	                   </div>
	                   <textarea name="remark"></textarea>
                    </form>
                </td>
            </tr>
        </table>
    </section>
</div>

<div id="popup_wrap" alert="Y" class="popup_wrap msg_box hidden">
    <header class="pop_header">
        <h1>ePR Decision</h1>
        <p class="pop_close" id="_popClose"><a>close</a></p>
    </header>
    <section class="pop_body">
        <form id="ePRApprovalForm">
	        <table class="type1">
	            <colgroup>
	                <col style="width: 130px;"/>
	                <col style="width: *;"/>
	            </colgroup>
                <c:if test="${!empty spcMembers}">
                    <tr>
                        <th>Assignment</th>
                        <td>
                            <select name="assignMemId">
                                <c:forEach items="${spcMembers}" var="p">
                                    <option value="${p.memId}">${p.userName}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </c:if>
	            <tr>
	                <th>Remark</th>
	                <td>
		                    <textarea id="ePRAprovalRemark" name="remark"></textarea>
		                    <ul class="center_btns" style="float: none;">
				                <li>
				                    <p class="btn_blue">
				                        <a id="ePRApprove">Approve</a>
				                    </p>
				                </li>
				                <li>
				                    <p class="btn_blue">
				                        <a id="ePRRejectApproval">Reject</a>
				                    </p>
				                </li>
				            </ul>
	                </td>
	            </tr>
	        </table>
        </form>
    </section>
</div>

<script>

    if (window.document.querySelector("#btnCancelEPR")) window.document.querySelector("#btnCancelEPRPop").parentElement.classList.remove("hidden")
    console.log(window.document.querySelector("#btnCancelEPR"))
    console.log(window.document.querySelector("#btnCancelEPRPop"))
    const defaultEPR = ${request}

    $(".ePRTitle").text(defaultEPR.title)
    $(".ePRKeyin").text(defaultEPR.submitDt)
    $("#ePRUsr").text(defaultEPR.memCode)
    $("#costCentreCode").text(defaultEPR.costCenter)
    $("#costCentreName").text(defaultEPR.costCenterText)
    $("#ePRStus").text(defaultEPR.stusName)
    $("#ePRNo").text("PR" + (defaultEPR.requestId.toString().padStart(5, "0")))
    $("#ePRApproval").html(
    		"<ul>" + `<li> - Request by "` + defaultEPR.reqstName + `" [` + moment(defaultEPR.submitDt).format("DD/MM/YYYY") + `]</li>` +
    		defaultEPR.approvals.sort((a, b) => a.seq - b.seq).map(a => `<li> - `+ a.stus + ` by "` + a.name + `" [` + (a.actDt ? moment(a.actDt).format("DD/MM/YYYY") : "") + `]</li>`).join("")
    		+ "</ul>"
    )
    const rejected = defaultEPR.approvals.filter(a => a.stus == 'Rejected')[0]
    $("#ePRReject").text(rejected ? (`Rejected by ` + rejected.name + `[` + moment(rejected.actDt).format("DD/MM/YYYY") + `]`) : "")

    const finalAppv = defaultEPR.approvals.reduce((finalAppv, appv) => appv.seq > finalAppv.seq ? appv : finalAppv, {seq: 0})
    $("#ePRFinal").text(finalAppv?.stus == 'Approved'  ? (`Approved by ` + finalAppv.name + ` [` + moment(finalAppv.actDt).format("DD/MM/YYYY") + `]`) : "")

    $(".ePRAssign").text(defaultEPR.assignedUser)
    $("#ePRRemark").text(defaultEPR.remark)

    $("#ePRNo").text("PR" + ((defaultEPR.requestId + "").padStart(5, '0')))
    $("#ePREditDistribute form > input:first-child").val(moment().format("DD/MM/YYYY"))
    document.getElementById("example_download").onclick = () => {
        window.location.href = ("${pageContext.request.contextPath}/resources/download/eAccounting/Delivery_CSV_File_Eg.xlsx")
    }

    $("#ePREditType").change((e) => {
    	if (e.target.value == 0) {
    		document.querySelector("#ePREditAssign").classList.remove("hidden")
    		document.querySelector("#ePREditDistribute").classList.add("hidden")
    	} else {
    		document.querySelector("#ePREditAssign").classList.add("hidden")
            document.querySelector("#ePREditDistribute").classList.remove("hidden")
    	}
    })

    $("#btnCancelEPRPop").click(() => {
        if (defaultEPR.stusName == "Approved") {
            Common.popupDiv("/eAccounting/ePR/cancelEPR.do?requestId=" + defaultEPR.requestId  , null, null , true , '_ePRCancelPop')
        }
    })

    document.querySelectorAll(".auto_file4 label").forEach(label => {
        label.onclick = () => {
            label.parentElement.querySelector("input[type=file]").click()
        }
    })

    $("#ePREditSubmit").click((e) => {
    	let form
    	if ($("#ePREditType").val() == 0) {
    		form = document.querySelector("#ePREditAssign form")
    	} else {
    		form = document.querySelector("#ePREditDistribute form")
    	}
    	const formData = new FormData()
    	const data = Object.fromEntries((new FormData(form)).entries())
    	if (!data.remark?.trim()) {
    		Common.alert("Please enter remark")
    		return
    	}
    	data.type = $("#ePREditType").val()
    	data.id = defaultEPR.requestId
    	formData.append("data", JSON.stringify(data))
    	if ($("#ePREditType").val() == 0 && defaultEPR.assignedUser == $("#ePREditAssign select[name=assignMemId] option:selected").text()) {
    		Common.alert("Kindly choose another PIC")
    		return
    	}
    	if ($("#ePREditType").val() == 1 && document.getElementById("ePRRcivFile").parentElement.parentElement.querySelector("input[type=file]").files.length == 0) {
            Common.alert("Kindly upload Receiver Information excel")
            return
    	} else if(document.getElementById("ePRRcivFile").parentElement.parentElement.querySelector("input[type=file]").files.length) {
    		formData.append("rciv", document.getElementById("ePRRcivFile").parentElement.parentElement.querySelector("input[type=file]").files[0])
        }
    	Common.showLoader()
    	fetch("/eAccounting/ePR/editEPR.do", {
            method: "POST",
            body: formData
        })
         .then((r) => {
            return r.json()
        })
        .then((d) => {
            if (d.success) {
                Common.alert("ePR edited!", () => {
                    $("#btnGuarViewClose").click()
                    getRequests()
                })
            } else {
                Common.alert("ePR creation failed! \n Kindly copy text below and raise ticket with it:\n" + JSON.stringify(data))
            }
        })
        .finally(() => {
            Common.removeLoader()
        })
    })

    document.querySelector("#ePRRciv > button").innerText = defaultEPR.recivName
    document.querySelector("#ePRRciv > button").onclick = (e) => {
        e.preventDefault()
        Common.showLoader()
        $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do", {
              httpMethod: "POST",
              contentType: "application/json;charset=UTF-8",
              data: {
                  fileId: defaultEPR.recivAtchId
              }
        })
        .done(() => {Common.removeLoader()})
    }
    if (defaultEPR.addName) {
	    document.querySelector("#ePRAdd > button").innerText = defaultEPR.addName
	    document.querySelector("#ePRAdd > button").onclick = (e) => {
	        e.preventDefault()
	        Common.showLoader()
	        $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do", {
	              httpMethod: "POST",
	              contentType: "application/json;charset=UTF-8",
	              data: {
	                  fileId: defaultEPR.addAtchId
	              }
	        })
	        .done(() => {Common.removeLoader()})
	    }
    } else {
    	document.querySelector("#ePRAdd > button").remove()
    }

    document.querySelectorAll(".click_add_on").forEach(el => {
    	el.onclick = (e) => {
            e.preventDefault()
            e.currentTarget.classList.toggle("on")
            document.querySelector("dd[data-caro=" + e.currentTarget.id + "]").style.display = e.currentTarget.classList.contains("on") ? "block" : "none"
            AUIGrid.resize(ePRApprovalGrid, 942, 380)
        }
    	el.click()
    })

    function chgTab(tab) {
        if (tab == "info") {
            document.getElementById("ePRInfo").classList.remove("hidden")
            document.getElementById("ePRDistribute").classList.add("hidden")
            document.getElementById("ePRDistribute").classList.remove("show")
            AUIGrid.resize(itemGrid, 942, 380)
        } else {
            document.getElementById("ePRDistribute").classList.remove("hidden")
            document.getElementById("ePRDistribute").classList.add("show")
            document.getElementById("ePRInfo").classList.add("hidden")
            AUIGrid.resize(ePRDistributeGrid, 942, 380)
        }
    }

    const ePRDistributeGrid = GridCommon.createAUIGrid("ePRDistributeGrid", [
	    {
	        dataField: 'item', headerText: 'Item', editable: false
	    },
	    {
	        dataField: 'quantity', headerText: 'Quantity', editable: false
	    },
	    {dataField: 'branch', headerText: 'Branch Name'},
	    {dataField: 'type', headerText: 'Type'},
	    {dataField: 'code', headerText: 'Code'},
	    {dataField: 'region', headerText: 'Region'},
	    {dataField: 'pic', headerText: 'PIC'},
	    {dataField: 'contact', headerText: 'Contact No.'},
	    {dataField: 'address', headerText: 'Address'},
	], '', {
	    usePaging: true,
	    pageRowCount: 20,
	    editable: false,
	    headerHeight: 60,
	    showRowNumColumn: true,
	    wordWrap: true,
	    showStateColumn: false,
	    softRemoveRowMode: false
	})

	AUIGrid.setGridData(ePRDistributeGrid, defaultEPR.deliveryDetails)

	const ePRApprovalGrid = GridCommon.createAUIGrid("ePRApprovalGrid", [
        {dataField: 'date', headerText: 'Date', editable: false},
        {dataField: 'userName', headerText: 'Name', editable: false},
        {dataField: 'stus', headerText: 'Decision', editable: false},
        {dataField: 'remark', headerText: 'Comment', editable: false}
    ], '', {
        usePaging: true,
        pageRowCount: 20,
        editable: false,
        headerHeight: 60,
        showRowNumColumn: true,
        wordWrap: true,
        showStateColumn: false,
        softRemoveRowMode: false
    })

    AUIGrid.setGridData(ePRApprovalGrid, defaultEPR.approvals.filter(a => a.stus != "Pending").map(a => ({date: a.actDt, userName: a.name, stus: a.stus, remark: a.remark})))

    const itemGrid = GridCommon.createAUIGrid("itemGrid", [
        {
            dataField: 'budgetCode', headerText: 'Budget Code', editable: false
        },
        {
            dataField: 'budgetName', headerText: 'Budget Name', editable: false
        },
        {dataField: 'eta', headerText: 'ETA<br/>(YYYY/MM/DD)', editRenderer: {
            type: 'CalendarRenderer'
        }},
        {dataField: 'item', headerText: 'Item'},
        {dataField: 'specs', headerText: 'Specification'},
        {dataField: 'quantity', headerText: 'Quantity'},
        {dataField: 'uom', headerText: 'UOM'},
        {dataField: 'remark', headerText: 'Remark'}
    ], '', {
        usePaging: true,
        pageRowCount: 20,
        editable: false,
        headerHeight: 60,
        showRowNumColumn: true,
        wordWrap: true,
        showStateColumn: false,
        softRemoveRowMode: false
    })

    AUIGrid.setGridData(itemGrid, defaultEPR?.items ? defaultEPR.items.map(i => ({...i, budgetName: i.budgetCodeText, eta: moment(i.eta).format("YYYY/MM/DD")})) : [])

    $("#_popClose").click(e => {
    	e.stopImmediatePropagation()
    	e.currentTarget.parentElement.parentElement.classList.toggle("hidden")
    })

    $("#editEPR").click(() => {
    	document.querySelector("#ePREditClose").parentElement.parentElement.parentElement.parentElement.parentElement.classList.remove("hidden")
    })

    $("#ePREditClose").click((e) => {
    	e.currentTarget.parentElement.parentElement.parentElement.parentElement.parentElement.classList.add("hidden")
    })

    $("#approvalPop").click(e => {
    	e.stopImmediatePropagation()
        document.querySelector("#_popClose")?.parentElement.parentElement.classList.toggle("hidden")
    })

    $("#ePRApprove").click(() => {
    	Common.showLoader()
    	const data = Object.fromEntries((new FormData(document.getElementById("ePRApprovalForm"))).entries())
    	data.stus = 5
    	data.requestId = defaultEPR.requestId
        fetch("/eAccounting/ePR/ePRApproval.do", {
        	method: "POST",
            body: JSON.stringify(data),
            headers: {"Content-Type": "application/json"}
        })
    	.then(() => {
    		Common.removeLoader()
    		Common.alert("ePR Approved", () => {
	    		$("#btnGuarViewClose").click()
	    		getRequests()
    		})
    	})
    })

    $("#approvalPop").click(e => {
        e.stopImmediatePropagation()
        document.querySelector("#_popClose")?.parentElement.parentElement.classList.toggle("hidden")
    })

    $("#ePRRejectApproval").click(() => {
    	Common.showLoader()
        const data = Object.fromEntries((new FormData(document.getElementById("ePRApprovalForm"))).entries())
        if (!data.remark?.trim()) {
        	Common.alert("Rejected approvals need to have remarks.")
        	Common.removeLoader()
        	return
        }
        data.stus = 6
        data.requestId = defaultEPR.requestId
        fetch("/eAccounting/ePR/ePRApproval.do", {
            method: "POST",
            body: JSON.stringify(data),
            headers: {"Content-Type": "application/json"}
        })
        .then(() => {
        	Common.removeLoader()
            Common.alert("ePR Rejected", () => {
            	$("#btnGuarViewClose").click()
	            getRequests()
            })
        })
    })

</script>