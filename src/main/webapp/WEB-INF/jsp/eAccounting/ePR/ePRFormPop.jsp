<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<style>
    .budgetContainer {
        display: flex;
        align-items: center;
        height: 100%;
    }

    .budgetContainer span{
        flex-grow: 1;
    }

    .budgetContainer img{
        cursor: pointer;
    }

    #itemGrid {
        margin-bottom: 5px;
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

    .hidden {
        display: none !important;
    }

    .show {
        display: block !important;
    }

    .popup_wrap.eprpop {
        width: 90% !important;
        left: 42%;
    }
</style>

<div class="popup_wrap eprpop">
    <header class="pop_header">
        <h1 id="ePRHeader"></h1>
        <ul class="right_opt">
          <li>
              <p class="btn_blue2">
                  <a id="ePRDraft">Save Draft</a>
              </p>
          </li>
          <li>
              <p class="btn_blue2">
                  <a id="ePRDelete">Delete ePR</a>
              </p>
          </li>
          <li>
              <p class="btn_blue2">
                  <a id="ePRSubmit">Submit</a>
              </p>
          </li>
	      <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
	    </ul>
    </header>
    <section class="pop_body">
        <ul class="tap_type1 num4">
            <li><a href="#" onClick="javascript:chgTab('info');">Basic Info</a></li>
            <li><a href="#" onClick="javascript:chgTab('distribute');">Distribution List</a></li>
        </ul>
        <article class="tap_area" id="ePRInfo">
            <form>
                <table class="type1" style="margin-bottom: 0;">
                    <colgroup>
                        <col style="width: 130px;"/>
                    </colgroup>
                    <tr>
                        <th scope="row">Title</th>
                        <td><input id="ePRTitle" type="text" style="width: 100%"/></td>
                    </tr>
                </table>
                <table class="type1" style="border-top: 0; margin-bottom: 0;">
                    <colgroup>
                        <col style="width: 130px;"/>
                    </colgroup>
                    <tr>
                        <th scope="row">Key in date</th>
                        <td><input id="keyinDt" readonly class="readonly" type="text" style="width: 100%"/></td>
                        <th scope="row">Creator User ID</th>
                        <td><input id="crtUsrNm" type="text" style="width: 100%" readonly class="readonly"/></td>
                    </tr>
                    <tr>
                        <th scope="row">Cost Centre Code</th>
                        <td>
                            <input type="text" style="width: 89%" id="costCenterCode" readonly class="readonly"/>
                            <a href="#" class="search_btn" id="search_cost_center">
                                <img src="/resources/images/common/normal_search.gif" alt="search">
                            </a>
                        </td>
                        <th scope="row">Cost centre Name</th>
                        <td><input type="text" style="width: 100%" id="costCenterName" readonly class="readonly"/></td>
                    </tr>
                </table>
                 <table class="type1" style="border-top: 0;">
                    <colgroup>
                        <col style="width: 130px;"/>
                    </colgroup>
                    <tr>
                        <th scope="row">Purpose / Remark</th>
                        <td><textarea id="ePRRemark" maxlength="500" placeholder="Enter up to 500 characters"></textarea></td>
                    </tr>
                    <tr>
                        <th scope="row">Receiver Information</th>
                        <td id="ePRRciv">
                            <div id="ePRRcivFileInput" class="auto_file4" style="width: auto;"><!-- auto_file start -->
						      <input type="file" title="file add" accept=".xlsx" />
					          <label for="ePRRcivFileInput">
					              <input id="ePRRcivFile" type="text" class="input_text" readonly class="readonly" placeholder="Only .xlsx file">
					              <span class="label_text2"><a href="#">File</a></span>
					          </label>
					          <span class="label_text2"><a id="example_download">Download CSV File</a></span>
						  </div>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Attachment</th>
                        <td id="ePRAdd">
                            <div class="auto_file4" style="width: auto;">
                              <input id="ePRAddFileInput" type="file" title="file add" accept=".zip,.7z,.gzip,.rar"/>
                              <label for="ePRAddFileInput">
                                  <input id="ePRAddFile" type="text" class="input_text" readonly class="readonly" placeholder="Only zip file">
                                  <span class="label_text2"><a href="#">File</a></span>
                              </label>
                          </div>
                        </td>
                    </tr>
                </table>
            </form>
            <input type="hidden" id="pBudgetCode" />
            <input type="hidden" id="pBudgetCodeName" />
            <div id="itemGrid"></div>
            <ul class="center_btns">
                <li>
                    <p class="btn_blue">
                        <a id="ePRAddRow">Add</a>
                    </p>
                </li>
                <li>
                    <p class="btn_blue">
                        <a id="ePRDeleteRow">Delete</a>
                    </p>
                </li>
            </ul>
        </article>
        <article class="tap_area" id="ePRDistribute">
            <div id="ePRDistributeGrid"></div>
        </aritcle>
        </article>
    </section>
</div>

<div class="popup_wrap hidden">
    <header class="pop_header">
        <h1>ePR Approver</h1>
        <ul class="right_opt">
          <li><p class="btn_blue2"><a href="#" id="approverClose">Close</a></p></li>
        </ul>
    </header>
    <section class="pop_body">
        <article class="tap_area">
            <ul class="right_btns">
                <li>
                    <p class="btn_blue2">
                        <a id="ePRSubmitApprv">Submit For Approval</a>
                    </p>
                </li>
            </ul>
            <table class="type1"><tbody><th><span class="must">* Approval doesn't have to be filled completely, final approval will be the last entry.</span></th></tbody></table>
            <div id="approvalGrid"></div>
        </article>
    </section>
</div>

<script>

    function fn_getTotalAmount() {}

    const defaultEPR = ${request}

    $("#crtUsrNm").val(defaultEPR.memCode)
    $("#costCenterCode").val(defaultEPR.costCenter)
    $("#costCenterName").val(defaultEPR.costCenterText)
    document.getElementById("ePRTitle").value = defaultEPR.title || ""
    document.getElementById("ePRRemark").value = defaultEPR.remark || ""

    let budgetRow;

    const stus = defaultEPR.stus
    const deleteFunctionButton = (el) => {
    	el.parentElement.parentElement.remove()
    }
    if (!stus) {
    	deleteFunctionButton(document.getElementById("ePRDelete"))
    } else if (stus != 116) {
    	deleteFunctionButton(document.getElementById("ePRDelete"))
    	deleteFunctionButton(document.getElementById("ePRDraft"))
    	deleteFunctionButton(document.getElementById("ePRSubmit"))
    	document.getElementById("ePRRciv").innerHTML = "<button>" + defaultEPR.recivName + "</button>"
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
    	document.getElementById("ePRAdd").innerHTML = "<button>" + defaultEPR.addName + "</button>"
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
    	document.querySelector("#ePRAddRow").remove()
    	document.getElementById("ePRDeleteRow").remove()
    	$("#ePRTitle").attr("disabled", true)
    	$("#ePRRemark").attr("disabled", true)
    }

    document.querySelectorAll(".auto_file4 label").forEach(label => {
    	label.onclick = () => {
    	    label.parentElement.querySelector("input[type=file]").click()
    	}
    })

    $("#ePRHeader").text((stus == null || stus == 116) ? "New Purchase Requisition" : "Purchase Requisition")

    function chgTab(tab) {
    	if (tab == "info") {
    	    document.getElementById("ePRInfo").classList.remove("hidden")
    	    document.getElementById("ePRDistribute").classList.add("hidden")
    	    document.getElementById("ePRDistribute").classList.remove("show")
    	    AUIGrid.resize(newGridID, 942, 380)
    	} else {
            document.getElementById("ePRDistribute").classList.remove("hidden")
            document.getElementById("ePRDistribute").classList.add("show")
            document.getElementById("ePRInfo").classList.add("hidden")
            AUIGrid.resize(ePRDistributeGrid, 942, 380)
    	}
    }

    const today = new Date()
    document.getElementById("keyinDt").value = moment(today).format("DD/MM/YYYY hh:mm A")

    var fn_setPopCostCenter = () => {
    	document.getElementById("costCenterCode").value = document.getElementById("search_costCentr").value
    	document.getElementById("costCenterName").value = document.getElementById("search_costCentrName").value
    }

    if (!stus || stus == 116) {
	    document.getElementById("example_download").onclick = () => {
	    	window.location.href = ("${pageContext.request.contextPath}/resources/download/eAccounting/Delivery_CSV_File_Eg.xlsx")
	    }
	    document.getElementById("search_cost_center").onclick = (e) => {
	        e.preventDefault()
	        Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop")
	    }
    }

    var newGridID = GridCommon.createAUIGrid("itemGrid", [
	    {
	    	dataField: 'budgetCode', headerText: 'Budget Code', renderer: {
	    		  type: 'TemplateRenderer',
	    	},
	    	labelFunction: function(rowIndex, _x, value) {
	    		return '<div class="budgetContainer"><input id="'+ 'budgetCode' + rowIndex +'" value="' + value + '" type="hidden" /><span>' + value + '</span><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.png" /></div>'
	    	},
	    	width: "25%"
	    },
	    {
	    	dataField: 'budgetCodeName', headerText: 'Budget Name', renderer: {
	    	    type: 'TemplateRenderer'
	    	},
	        labelFunction: function(rowIndex, _x, value) {
	            return '<div class="budgetContainer"><input id="'+ 'budgetName' + rowIndex +'" value="' + value + '" type="hidden" /><span>' + value + '</span></div>'
	        },
	        width: "25%"
	    },
	    {dataField: 'eta', headerText: 'ETA<br/>(YYYY/MM/DD)', editRenderer: {
	    	type: 'BTCalendarRenderer',
	    	btOpts: {
	    		beforeShowDay: (dt) => {
	    			return !moment(dt).isBefore(moment())
	    		}
	    	}
	    },width: "25%"},
	    {dataField: 'item', headerText: 'Item',width: "25%"},
	    {dataField: 'specs', headerText: 'Specification',width: "25%"},
	    {dataField: 'quantity', headerText: 'Quantity', editRenderer: {
	    	type: 'NumberStepRenderer',
	    	min: 1,
	    	max: null
	    },width: "25%"},
	    {dataField: 'uom', headerText: 'UOM', editRenderer: {
	    	type: 'DropDownListRenderer',
	    	list: ['pc(s)', 'unit(s)', 'set(s)'] // hard coded because need history for previous record's units
	    },width: "25%"},
	    {dataField: 'remark', headerText: 'Remark',width: "25%"}
	], '', {
	    usePaging: true,
	    pageRowCount: 20,
	    editable: !stus || stus == 116 ? true : false,
	    headerHeight: 60,
	    showRowNumColumn: true,
	    wordWrap: true,
	    showStateColumn: false,
	    softRemoveRowMode: false
	})

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

	const bindBudgetCodeEvent = () => {
		if (stus && stus != 116) return
		$(".budgetContainer img").off("click").on("click", (event) => {
            budgetRow = $(event.target.parentElement).find("input").attr("id").split("budgetCode")[1]
            Common.popupDiv("/eAccounting/webInvoice/budgetCodeSearchPop.do",data = {
                    rowIndex : budgetRow
                    ,costCentr : $("#costCenterCode").val()
                    ,costCentrName : $("#costCenterName").val()
            }, null, true, "budgetCodeSearchPop")
        })
	}

	AUIGrid.setGridData(newGridID, defaultEPR?.items ? defaultEPR.items.map(i => ({...i, budgetCodeName: i.budgetCodeText, eta: moment(i.eta).format("YYYY/MM/DD")})) : [])
	bindBudgetCodeEvent()
	AUIGrid.setGridData(ePRDistributeGrid, defaultEPR?.deliveryDetails || [])


	AUIGrid.bind(newGridID, "addRow", () => {
		bindBudgetCodeEvent()
	})

	AUIGrid.bind(newGridID, "cellEditEnd", () => {
		bindBudgetCodeEvent()
	})

	AUIGrid.bind(newGridID, "removeRow", () => {
        bindBudgetCodeEvent()
    })

	function fn_setPopBudgetData() {
    	AUIGrid.updateRow(newGridID, {budgetCode: $("#pBudgetCode").val(), budgetCodeName: $("#pBudgetCodeName").val()}, budgetRow)
    	bindBudgetCodeEvent()
    }

	$("#ePRAddRow").click(() => {
		AUIGrid.addRow(newGridID, {}, "last")
	})

	document.getElementById("ePRDeleteRow") && (document.getElementById("ePRDeleteRow").onclick = () => {
		AUIGrid.removeRow(newGridID, "selectedIndex")
	})

	document.getElementById("ePRDelete") && (document.getElementById("ePRDelete").onclick = e => {
		e.preventDefault()
		Common.showLoader()
		if (defaultEPR.requestId) {
			fetch("/eAccounting/ePR/deleteEPR.do?requestId=" + defaultEPR.requestId, {
				method: "POST"
			})
			.then(() => {
				Common.removeLoader()
				Common.alert("ePR deleted!", () => {
					$(".pop_header a:contains(CLOSE)").click()
                    getRequests()
                })
			})
		} else {
			Common.removeLoader()
		}
	})

	const checkForm = () => {
		const [ePRTitle, keyinDt, crtUsrNm, costCenterCode, ePRRemark] = [document.getElementById("ePRTitle").value, $("#keyinDt").val(), document.querySelector("#crtUsrNm").value, $("#costCenterCode").val(), document.getElementById("ePRRemark").value]
		if (ePRTitle.trim().length == 0) {
			Common.alert("Please fill in ePR title")
			return false
		}
		if (costCenterCode.trim().length == 0) {
            Common.alert("Please fill in Cost Center")
            return false
        }
		if (ePRRemark.trim().length == 0) {
            Common.alert("Please fill in ePR remark")
            return false
        }
		const items = AUIGrid.getGridData(newGridID)
		if (!items || items.length == 0) {
			Common.alert("Kindly insert ePR items")
			return false
		}
		if (document.getElementById("ePRRcivFile").parentElement.parentElement.querySelector("input[type=file]").files.length == 0) {
			Common.alert("Kindly upload Receiver Information excel")
			return false
		}
		for (let i = 0; i < items.length; i++) {
			const {budgetCode, budgetCodeName, eta, item, specs, quantity, uom, remark} = items[i]
			if (!budgetCode || budgetCode.trim().length == 0) {
	            Common.alert("Please fill in budget code")
	            return false
	        }
			if (!budgetCode || budgetCode.trim().length == 0) {
                Common.alert("Please fill in budget code")
                return false
            }
			if (!budgetCodeName || budgetCodeName.trim().length == 0) {
                Common.alert("Please fill in budget code name")
                return false
            }
			if (!eta || eta.trim().length == 0) {
                Common.alert("Please fill in receive eta")
                return false
            }
			if (!item || item.trim().length == 0) {
                Common.alert("Please fill in ePR item")
                return false
            }
			if (!specs || specs.trim().length == 0) {
                Common.alert("Please fill in ePR item specification")
                return false
            }
			if (!quantity) {
                Common.alert("Please fill in ePR item amount")
                return false
            }
			if (!uom || uom.trim().length == 0) {
                Common.alert("Please fill in ePR item UOM")
                return false
            }
		}
		return true
	}

	document.getElementById("ePRSubmit") && (document.getElementById("ePRSubmit").onclick = e => {
		e.preventDefault()
		if (checkForm()) {
			document.querySelectorAll(".popup_wrap").forEach(pop => {
				pop.classList.toggle("hidden")
				AUIGrid.resize(approvalGrid, 942, 380)
			})
		}
	})

	function doneSelectAppr(members) {
		Common.showLoader()
        const [ePRTitle, keyinDt, crtUsrNm, costCenterCode, ePRRemark] = [document.getElementById("ePRTitle").value, $("#keyinDt").val(), document.querySelector("#crtUsrNm").value, $("#costCenterCode").val(), document.getElementById("ePRRemark").value]
        const data = JSON.stringify({
            ePRTitle, keyinDt: moment(keyinDt, "DD/MM/YYYY hh:mm A").format("YYYY/MM/DD"), crtUsrNm, costCenterCode, ePRRemark, requestId: defaultEPR.requestId, members,
            items: AUIGrid.getGridData(newGridID).map(i => {
                const {budgetCode, eta, item, specs, quantity, uom, remark} = i
                return {budgetCode, eta, item, specs, quantity, uom, remark}
            })
        })
        const formData = new FormData()
		formData.append("rciv", document.getElementById("ePRRcivFile").parentElement.parentElement.querySelector("input[type=file]").files[0])
        formData.append("add", document.getElementById("ePRAddFile").parentElement.parentElement.querySelector("input[type=file]").files[0])
		formData.append("data", data)
		fetch("/eAccounting/ePR/submitEPR.do", {
        	method: "POST",
            body: formData
        })
        .then((r) => {
            return r.json()
        })
        .then((d) => {
            if (d.success) {
                Common.alert("You have successfully submitted a new Purchase Request.<br/>PR No. : PR" + d.success.toString().padStart(5, "0"), () => {
                	$(".pop_header a:contains(CLOSE)").click()
                    getRequests()
                })
            } else {
            	if (d.err) {
            		Common.alert(d.err)
            	} else {
	                Common.alert("ePR creation failed! \n Kindly copy text below and raise ticket with it:\n" + data)
            	}
            }
        })
        .finally(() => {
        	Common.removeLoader()
        })
	}

	document.getElementById("ePRDraft") && (document.getElementById("ePRDraft").onclick = e => {
		e.preventDefault()
	    Common.showLoader()
		const [ePRTitle, keyinDt, crtUsrNm, costCenterCode, ePRRemark] = [document.getElementById("ePRTitle").value, $("#keyinDt").val(), document.querySelector("#crtUsrNm").value, $("#costCenterCode").val(), document.getElementById("ePRRemark").value]
	    const data = JSON.stringify({
            ePRTitle, keyinDt, crtUsrNm, costCenterCode, ePRRemark, requestId: defaultEPR.requestId,
            items: AUIGrid.getGridData(newGridID).map(i => {
                const {budgetCode, eta, item, specs, quantity, uom, remark} = i
                return {budgetCode, eta, item, specs, quantity, uom, remark}
            })
        })
    	fetch("/eAccounting/ePR/draftEPR.do",
    		{
    	        method: "POST",
    	        headers: {"Content-Type": "application/json"},
    	        body: data
    		}
    	)
    	.then((r) => {
    		return r.json()
    	})
    	.then((d) => {
    		Common.removeLoader()
    		if (d.success) {
    			Common.alert("Draft saved!", () => {
    				$(".pop_header a:contains(CLOSE)").click()
    				getRequests()
    			})
    		} else if (d.err) {
    			Common.alert(d.err)
    		} else {
    			Common.alert("Draft creation failed! \n Kindly copy text below and raise ticket with it:\n" + data)
    		}
	    })
	})

	let apprvRow;

    const approvalGrid = GridCommon.createAUIGrid("approvalGrid", [
        {dataField: "memCode", headerText: 'User ID', editable: false, renderer: {
            type: "TemplateRenderer"
        },
        labelFunction: function (rowIndex, _x, value) {
            return `<div class="apprvContainer" style='display: flex; justify-content: center; align-items: center;'><p style="flex: 1;">` + value + `</p><img onclick="bindApprovalEvent(` + rowIndex + `)" src="${pageContext.request.contextPath}/resources/images/common/normal_search.png"/></div>`
        }},
        {dataField: "name", headerText: 'Name', editable: false},
        {editable: false, renderer: {
            type: "ButtonRenderer",
            labelText: "Clear",
            onclick: function (e) {
                if (e != 4) {
                    AUIGrid.updateRow(approvalGrid, {memCode: "", name: ""}, e)
                }
            }
        }}
    ], '', {
        usePaging: true,
        pageRowCount: 20,
        editable: true,
        headerHeight: 60,
        showRowNumColumn: true,
        wordWrap: true,
        showStateColumn: false,
        softRemoveRowMode: false,
        enableSorting: false
    })
    function bindApprovalEvent(i) {
        if (i == 4) return
        apprvRow = i
        Common.popupDiv("/common/memberPop.do", {callPrgm:"TR_BOOK_ASSIGN"}, null, true)
    }

    AUIGrid.setGridData(approvalGrid, [{},{},{},{},{memCode: "${f.memCode}", name: "${f.fullName}"}])
    function fn_loadOrderSalesman(_x, _y, _z, memCode, name) {
        if (!AUIGrid.getColumnValues(approvalGrid, "memCode", true).find((m) => m == memCode)) {
            AUIGrid.updateRow(approvalGrid, {memCode, name}, apprvRow)
        } else {
            Common.alert("User already in approval line.")
        }
    }

    $("#ePRSubmitApprv").click(() => {
        const members = AUIGrid.getGridData(approvalGrid).filter(i => i.memCode)
        if (members.length > 1) {
            doneSelectAppr(members)
        }
    })

    $("#approverClose").click((e) => {
    	e.preventDefault()
    	document.querySelectorAll(".popup_wrap").forEach(pop => {
            pop.classList.toggle("hidden")
            AUIGrid.resize(newGridID, 942, 380)
        })
    })
</script>