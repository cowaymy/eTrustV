<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>
    tr select {
        width: 100% !important;
    }
</style>

<div id="popup_wrap_download" class="popup_wrap size_mid"><!-- popup_wrap start -->
    <header class="pop_header">
        <h1>
	        Attendance Excel
        </h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
		</ul>
    </header>
    <section class="pop_body"><!-- pop_body start -->
        <form id="attendanceExcel">
            <table class="type1">
                <colgroup>
                    <col style="width: 130px;"/>
                    <col style="width: *;"/>
                    <col style="width: 130px;"/>
                    <col style="width: *;"/>
                </colgroup>
                <tbody>
                    <tr>
                        <th>Month</th>
                        <td colspan="3"><input type="text" id="monthYear" name="calMonthYear" title="Month" class="j_date2 w100p" placeholder="Choose one" /></td>
                    </tr>
                    <tr>
                        <th>Org Code</th>
                        <td><select form="attendanceExcel" id="orgCode" name="orgCode"></select></td>
                        <th>Group Code</th>
                        <td><select form="attendanceExcel" id="grpCode" name="grpCode"></select></td>
                    </tr>
                    <tr>
                        <th>Dept Code</th>
                        <td><select form="attendanceExcel" id="deptCode" name="deptCode"></select></td>
<!--                         <th>HP Type</th> -->
<!--                         <td><select id="hpType"> -->
<!--                             <option value=''>Choose One</option> -->
<!--                             <option value="Y">Neo Pro</option> -->
<!--                             <option value="N">Non-Neo Pro</option> -->
<!--                         </select></td> -->
                        <th>HP Code</th>
                        <td><select form="attendanceExcel" id="memCode" name="memCode"></select></td>
                    </tr>
<!--                     <tr> -->
<!--                         <th>HP Code</th> -->
<!--                         <td colspan="3"><select form="attendanceExcel" id="memCode" name="memCode"></select></td> -->
<!--                     </tr> -->
                </tbody>
            </table>
        </form>
        <ul class="center_btns">
            <li><p class="btn_blue2 big">
                <a href="#" id="genAttendance">Generate</a>
            </p></li>
        </ul>
    </section>
</div>

<script>
    $("#monthYear").val(moment().format("MM/YYYY"))
    ${memLvl} == 4 && $("#memCode").html("<option value=${memCode}>${memCode}</option>")
    "${deptCode}" && $("#deptCode").html("<option value=${deptCode}>${deptCode}</option>")
    "${grpCode}" && $("#grpCode").html("<option value=${grpCode}>${grpCode}</option>")
    "${orgCode}" && $("#orgCode").html("<option value=${orgCode}>${orgCode}</option>")
    const codes = [$("#orgCode"), $("#grpCode"), $("#deptCode")]
    const convertCodes = ["6988", "6989", "6990"]
    let setEntry = true
    const setOptions = (el, d) => {
    	el.html("<option value=''>Choose One</option>" + d.map(r => {
    		const disp = r.code
    		let val = r.code
    		if (disp.includes(" - ")) {
    			val = disp.split(" - ")[0]
    		}
    		return "<option value=" + r.code + ">" + r.code + "</option>"
    	}).join(''))
    }
    codes.forEach((el, i) => {
    	if (!el.val()) {
    		if (setEntry) {
    			setEntry = false
    			if (i == 0) {
    				fetch("/attendance/getDownline.do")
                    .then(r => r.json())
                    .then(d => {
                    	setOptions(el, d)
                    })
    			} else {
    				fetch("/attendance/getDownline.do?managerCode=" + codes[i - 1].val())
    				.then(r => r.json())
    				.then(d => {
    					setOptions(el, d)
    				})
    			}
    		}
    		el.change(() => {
    			$("#memCode").html('')
                if (i == 2) {
                	fetch("/attendance/getDownlineHP.do?managerCode=" + el.val() + ($("#hpType").val() ? "&isNeo=" + $("#hpType").val() : ""))
                    .then(r => r.json())
                    .then(d => {
                    	setOptions($("#memCode"), d)
                    })
//                     $("#hpType").off('change').on('change', () => {
// 				        if ($("#deptCode").val()) {
// 				            fetch("/attendance/getDownlineHP.do?managerCode=" + $("#deptCode").val() + ($("#hpType").val() ? "&isNeo=" + $("#hpType").val() : ""))
// 				            .then(r => r.json())
// 				            .then(d => {
// 				                setOptions($("#memCode"), d)
// 				            })
// 				        }
// 				    })
                } else {
	    			fetch("/attendance/getDownline.do?managerCode=" + el.val())
	    			.then(r => r.json())
	    			.then(d => {
	    				if (codes[i + 1]) {
	    					setOptions(codes[i + 1], d)
	    				}
	    			})
                }
    		})
    	}
    })

    const checkLate = (d, lvl, type) => {
    	if (type != "A0001") return false
    	const compare = (lvl == 4) ? "11:00:01" : "09:00:01"
    	return moment(d).isAfter(moment(moment(d).format("YYYY/MM/DD ") + compare, "YYYY/MM/DD hh:mm:ss"))
    }

    $("#genAttendance").click(() => {
    	const params = new URLSearchParams($("#attendanceExcel").serialize())
    	params.set("calMonthYear", params.get("calMonthYear").split("/").reverse().join(""))
    	if (true) {
    		Common.showLoader()
	    	fetch("/attendance/genAttendanceExcelData.do?" + params.toString())
	    	.then(resp => resp.json())
	    	.then(ds => {
	    		const sheet = XLSX.utils.json_to_sheet(ds.map(d => {
	    			const {date, time, day, orgCode, grpCode, deptCode, hpCode, hpType, late} = d
	    			return {date, time, day, orgCode, grpCode, deptCode, hpCode, hpType, "QR - A0001": d["QR - A0001"], "Public Holiday - A0002": d["Public Holiday - A0002"], "State Holiday - A0003": d["State Holiday - A0003"], "RFA - A0004": d["RFA - A0004"], "Waived - A0005": d["Waived - A0005"], late}
	    		}), {header: ["date", "time", "day", "orgCode", "grpCode", "deptCode", "hpCode", "hpType", "QR - A0001", "Public Holiday - A0002", "State Holiday - A0003", "RFA - A0004", "Waived - A0005", "late"]})
	    		const book = XLSX.utils.book_new()
	    		XLSX.utils.book_append_sheet(book, sheet, 'Sheet1')
	    		const bytes = XLSX.write(book, { bookType:'xlsx', bookSST:false, type:'binary' })
	    		const byteLength = bytes.length
	    		const buffer = new ArrayBuffer(byteLength)
	    		const chars = new Uint8Array(buffer)
	    		for(let i = 0; i < byteLength; i ++) chars[i] = bytes.charCodeAt(i)
	    		const file = new File([buffer], 'AttendanceRaw.xlsx')
	    		const url = URL.createObjectURL(file)
	    		const a = document.createElement('a')
				a.href = url;
				a.download = file.name;
				a.click()
				Common.removeLoader()
	    	})
    	} else {
    		Common.alert("Kindly Choose Org code.")
    	}
	})
</script>