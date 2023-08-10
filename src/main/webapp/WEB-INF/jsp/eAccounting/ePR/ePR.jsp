<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<aside class="title_line">
    <h2>ePurchase Requisition</h2>
    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li><p class="btn_blue"><a id="ePRSearch">Search</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
            <li><p class="btn_blue"><a onclick="fn_newPRPop()">New</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li><p class="btn_blue"><a onclick="resetEPRForm()">Clear</a></p></li>
        </c:if>
    </ul>
</aside>

<section class="search_table">
    <form id="ePRSearchForm">
	    <table class="type1">
	        <colgroup>
	            <col style="width: 130px;"/>
	            <col style="width: *;"/>
	            <col style="width: 130px;"/>
	            <col style="width: *;"/>
	        </colgroup>
	        <tr>
	            <th>E-PR No.</th>
	            <td><input type="text" name="ePRNo" /></td>
	            <th>E-PR Status</th>
	            <td>
	                <select name="ePRStus">
	                    <option value="">Choose One</option>
	                    <option value="120">Draft</option>
	                    <option value="121">Submitted</option>
	                    <option value="44">Pending for Approval</option>
	                    <option value="5">Approved</option>
	                    <option value="6">Rejected</option>
	                    <option value="10">Cancelled</option>
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th>Request Create Date</th>
	            <td>
	                <div class="date_set w100p"><!-- date_set start -->
					    <p><input name="start" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
					    <span>TO</span>
					    <p><input name="end" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
				    </div><!-- date_set end -->
	            </td>
	            <th>Creator</th>
	            <td>
	                <input type="text" name="crt"/>
	            </td>
	        </tr>
	        <tr>
	            <th></th>
	            <td></td>
	            <th>Person In Charge</th>
	            <td>
		            <select name="pic">
		               <option value="">Choose One</option>
		            </select>
	            </td>
	        </tr>
	    </table>
    </form>
	<aside class="link_btns_wrap">
	    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
	    <dl class="link_list">
	        <dt>Link</dt>
	        <dd>
	            <ul class="btns">
	                <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
	                   <li><p class="link_btn"><a href="#" id="btnTransEPR">PR Transcript</a></p></li>
                    </c:if>
                    <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
                        <li><p class="link_btn"><a href="#" id="btnRawEPR">PR Summary RAW</a></p></li>
                    </c:if>
                    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		                <li><p class="link_btn"><a href="#" id="btnCancelEPR">Cancel PR</a></p></li>
                    </c:if>
	            </ul>
	            <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	        </dd>
	    </dl>
	</aside>
</section>


<div id="requestsGrid"></div>

<form id="eprRaw">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/visualcut/eprRaw.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="ePRRaw" />

    <input type="hidden" id="REQUEST_IDS" name="REQUEST_IDS" value="">
</form>

<form id="eprTranscript">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/visualcut/eprTranscript.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="ePRTranscript" />

    <input type="hidden" id="request_id" name="request_id" value="">
</form>

<script>
    var rowItem;
    const requests = ${requests}

    const genGrid = (data) => {
    	document.getElementById("requestsGrid").innerHTML = ""
	    const requestsGrid = GridCommon.createAUIGrid('requestsGrid', [
	        {
	        	dataField: 'eprNo', headerText: 'E-PR No.', editable: false
	        },
	        {
	            dataField: 'title', headerText: 'Title', editable: false
	        },
	        {
	            dataField: 'costCenter', headerText: 'Cost Centre Code', editable: false
	        },
	        {
	            dataField: 'costCenterText', headerText: 'Cost Centre Name', editable: false
	        },
	        {
	            dataField: 'userName', headerText: 'Requestor', editable: false
	        },
	        {
	        	dataField: 'crtDt', headerText: 'Request Create Date', editable: false
	        },
	        {
	        	dataField: 'code', headerText: 'Status', editable: false
	        }
	    ])
	    AUIGrid.setGridData(requestsGrid, data.map(i => ({...i, crtDt: moment(i.crtDt).format("YYYY/MM/DD")})))

	    AUIGrid.bind(requestsGrid, 'cellDoubleClick', (event) => {
	        Common.popupDiv("/eAccounting/ePR/viewEPRForm.do?requestId=" + event.item.eprNo.replace("PR", ""), {}, null, true, '_ePRViewPop');
	    })

	    AUIGrid.bind(requestsGrid, 'cellClick', (e) => {
	    	rowItem = e.item
	    })
    }
    //genGrid(requests)

    const resetEPRForm = () => {
    	document.getElementById("ePRSearchForm").reset()
    }

    const fn_newPRPop = () => {
    	Common.popupDiv("/eAccounting/ePR/newEPRPop.do"  , null, null , true , '_ePRNewPop');
    }

    $("#btnCancelEPR").click(() => {
    	if (rowItem && rowItem.code == "APV") {
	    	Common.popupDiv("/eAccounting/ePR/cancelEPR.do?requestId=" + rowItem?.eprNo.replace("PR", "")  , null, null , true , '_ePRCancelPop')
    	} else {
    		Common.alert("Kindly select an approved entry")
    	}
    })

    fetch("/eAccounting/ePR/spcMembers.do")
    .then(resp => resp.json())
    .then(d => {
    	d.forEach((p) => {
	    	document.querySelector("select[name=pic]").innerHTML += "<option value=" + p.memId + (p.userName == "${currName}" ? " selected" : "") + ">" + p.userName + "</option>"
    	})
    	getRequests()
    })

    $("#ePRSearch").click(getRequests)

    function getRequests(callback) {
    	Common.showLoader()
	    const data = Object.fromEntries((new FormData(document.getElementById("ePRSearchForm"))).entries())
	    data.ePRNo = data.ePRNo.replace("PR", "")
        fetch("/eAccounting/ePR/getEPR.do?" + (new URLSearchParams(data)).toString())
        .then(resp => resp.json())
        .then(d => {
        	genGrid(d)
        	callback && callback(d)
        })
        .finally(() => {
        	Common.removeLoader()
        })
    }

    $("#btnRawEPR").click(() => {
    	getRequests((d) => {
    		$("#REQUEST_IDS").val(d.map(r => r.eprNo.replace("PR", "")).join(","))
    		var option = {
                isProcedure : true
            };

             Common.report("eprRaw", option);
    	})
    })

    $("#btnTransEPR").click(() => {
    	$("#request_id").val(rowItem?.eprNo.replace("PR", ""))
    	var option = {
            isProcedure : true
        };

        Common.report("eprTranscript", option);
    })
</script>