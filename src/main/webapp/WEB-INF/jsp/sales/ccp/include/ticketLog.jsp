<article class="tap_area">
    <article class="grid_wrap">
        <div id="logGrid" style="width:100%; height:480px; margin:0 auto;"></div>
    </article>
</article>

<script>
    $(() => {
    	const ticketStatus = [{codeId: 1, codeName: 'Active'}, {codeId: 34, codeName: 'Solved'}, {codeId: 35, codeName: 'Unsolved'}]
    	const logs = [
            <c:forEach var="log" items="${logs}">
                {
                    logContent: `<c:out value="${log.logContent}" />`,
                    crtDt: new Date(`<c:out value="${log.crtDt}" />`),
                    userName: `<c:out value="${log.userName}" />`,
                    status: ticketStatus.find(s => s.codeId == `<c:out value="${log.status}" />`).codeName,
                    ticketType: `${ticketDetails.code}`
                },
            </c:forEach>
        ].sort((a,b) => a.crtDt > b.crtDt ? -1 : 1)
	    const logGrid = GridCommon.createAUIGrid("logGrid", [
	        {dataField: 'status', headerText: 'Ticket Status'},
	        {dataField: 'ticketType', headerText: 'Ticket Type'},
	        {dataField: 'logContent', headerText: 'Details of<br>Query and feedback'},
	        {dataField: 'upd', headerText: 'Responder<br>Details'}
	    ], '', {
	        usePaging: true,
	        pageRowCount: 20,
	        editable: false,
	        headerHeight: 60,
	        showRowNumColumn: true,
	        wordWrap: true,
	        showStateColumn: false
	    })

	    const formatDateTime = (dt, usr) => {
	        return dt.getDate().toString().padStart(2, '0') + '/' + (dt.getMonth() + 1).toString().padStart(2, '0') + '/' + dt.getUTCFullYear() + `
	        ` + (dt.getHours() >= 12 ? 'PM ' : 'AM ') + (dt.getHours() == 12 || dt.getHours() == 24 ? 12 : dt.getHours() % 12).toString().padStart(2, '0') + ':' + dt.getMinutes().toString().padStart(2, '0') + ':' + dt.getSeconds().toString().padStart(2, '0') + `
	        ` + '(' + usr + ')'
	    }

	    AUIGrid.setGridData(logGrid, logs.map(l => (
	        {
	            ...l,
	            upd: formatDateTime(l.crtDt, l.userName)
	        }
	    )))
    })
</script>