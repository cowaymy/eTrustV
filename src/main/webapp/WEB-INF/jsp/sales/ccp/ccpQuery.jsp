<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<form id="ccpTicketSearch">
    <ul class="right_btns">
        <li class="btn_blue"><a onClick="fn_new_ticket()"><spring:message code="sal.btn.new" /></a></li>
        <li class="btn_blue"><a id="ccpTicketSearchBtn"><spring:message code="sal.btn.search" /></a></li>
    </ul>
	<table class="type1">
		<tbody>
		   <tr>
		       <th scope="row"><spring:message code="sal.text.ordNo" /></th>
	           <td><input type="text" title="" placeholder="" class="w100p"  name="ordNo" id = "ordNo"/></td>
	           <th scope="row"><spring:message code="sal.text.detpCode" /></th>
	           <td><input type="text" title="" placeholder="" class="w100p"  name="deptCode" id = "deptCode" value="${deptCode}"/></td>
	           <th scope="row"><spring:message code="sal.title.text.ccpStatus" /></th>
	           <td><select class="w100p"  name="ccpStatus" id = "ccpStatus"></select></td>
		   </tr>
		   <tr>
		       <th scope="row"><spring:message code="sal.text.memtype" /></th>
	           <td><select class="w100p"  name="memType" id = "memType"></select></td>
	           <th scope="row"><spring:message code="sal.title.ccpTicketType" /></th>
	           <td><select class="w100p"  name="ticketType" id = "ticketType"></select></td>
	           <th scope="row"><spring:message code="sal.title.ccpTicketStus" /></th>
	           <td><select class="w100p"  name="ticketStatus" id = "ticketStatus"></select></td>
		   </tr>
		</tbody>
	</table>
	<section class="search_result">
	   <article class="grid_wrap">
		   <div id="ticketGrid" style="width:100%; height:480px; margin:0 auto;"></div>
	   </article>
	</section>
</form>

<script>

    const formatDateTime = (time, usr) => {
    	let dt = new Date(time)
    	return dt.getDate().toString().padStart(2, '0') + '/' + (dt.getMonth() + 1).toString().padStart(2, '0') + '/' + dt.getUTCFullYear() + `
    	` + (dt.getHours() >= 12 ? 'PM ' : 'AM ') + (dt.getHours() == 12 || dt.getHours() == 24 ? 12 : dt.getHours() % 12).toString().padStart(2, '0') + ':' + dt.getMinutes().toString().padStart(2, '0') + ':' + dt.getSeconds().toString().padStart(2, '0') + `
    	` + '(' + usr + ')'
    }

    const ticketTypePromise = fetch("/common/selectCodeList.do?groupCode=545")
    .then(r => r.json())
    const ticketStusPromise = fetch("/common/selectCodeGroup.do?ind=CCP_T_STUS")
    .then(r => r.json())

    Promise.all([ticketTypePromise, ticketStusPromise])
    .then(([ticketType, ticketStus]) => {
    	ticketStus = ticketStus.map(i => ({...i, codeId: i.code}))
    	let ccpStatus = [{codeId: 1, codeName: 'Active'}, {codeId: 5, codeName: 'Approved'}, {codeId: 6, codeName: 'Rejected'}]
        let memberType = [{codeId: 2, codeName: 'CD'}, {codeId: 1, codeName: 'HP'}, {codeId: 7, codeName: 'HT'}, {codeId: 3, codeName: 'CT'}]

    	doDefCombo(ticketType, '', 'ticketType','S')
    	doDefCombo(ticketStus, '', 'ticketStatus','S')
    	doDefCombo(ccpStatus, '', 'ccpStatus','S')
    	doDefCombo(memberType, '${memType}', 'memType','S')

    	document.getElementById('ccpTicketSearchBtn').onclick = (event) => {
            event.preventDefault()
    		Common.showLoader()
            fetch("/sales/ccp/selectCcpTicket.do?" + $("#ccpTicketSearch").serialize())
            .then(r => r.json())
            .then(resp => {
                resp = resp.map(i => {
                    return {
                        ...i,
                        ccpStus: ccpStatus.find(z => z.codeId == i.ccpStusId)?.codeName,
                        type: ticketType.find(z => z.codeId == i.typeId)?.codeName,
                        status: ticketStus.find(z => z.code == i.status)?.codeName,
                        created: formatDateTime(i.crtDt, i.userName),
                        responded: i.respDt ? formatDateTime(i.respDt, i.respUsr) : null
                    }
                })
                Common.removeLoader()
                AUIGrid.setGridData(ticketGrid, resp)
            })
        }

    	if ("${deptCode}") {
            $("#deptCode").prop("readonly", true)
            $("#memType > option").prop("disabled", true)
        }
    })

    const ticketGrid = GridCommon.createAUIGrid("ticketGrid", [
        {dataField: 'ticketId', visible: false},
        {dataField: 'salesOrdNo', headerText: '<spring:message code="sal.title.text.ordBrNo" />'},
        {dataField: 'name', headerText: '<spring:message code="sal.title.text.customerName" />'},
        {dataField: 'chsStus', headerText: 'CHS Status'},
        {dataField: 'chsRsn', headerText: 'CHS Reason'},
        {dataField: 'ccpStus', headerText: '<spring:message code="sal.title.text.ccpBrStus" />'},
        {dataField: 'ccpRem', headerText: '<spring:message code="sal.title.text.ccpBrRem" />'},
        {dataField: 'type', headerText: 'CCP<br>Query Type'},
        {dataField: 'ticketQuery', headerText: 'CCP<br>Query'},
        {dataField: 'feedback', headerText: 'CCP<br>Query Feedback'},
        {dataField: 'status', headerText: 'CCP<br>Query Status'},
        {dataField: 'created', headerText: 'Query<br>Date & Time'},
        {dataField: 'responded', headerText: 'Responder<br>(At_By)'}
    ], '', {
    	usePaging: true,
    	pageRowCount: 20,
    	editable: false,
    	headerHeight: 60,
    	showRowNumColumn: true,
    	wordWrap: true,
    	showStateColumn: false
    })

    AUIGrid.bind(ticketGrid, 'cellDoubleClick', (event) => {
    	Common.popupDiv("/sales/ccp/editCCPTicketPop.do?ticketId=" + event.item.ticketId, {}, null, true);
    })

    const fn_new_ticket = () => {
    	Common.popupDiv("/sales/ccp/newCCPTicketPop.do", {}, null, true);
    }
</script>