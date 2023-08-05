<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>
.hidden {
	display: none !important;
}
</style>

<section id="content">
	<aside class="title_line">
		<h2>HP Organization Reporting Branches</h2>
		<ul class="right_btns">
			<li><p class="btn_blue">
					<a href="#" onclick="addLocPop()">Add Location</a>
				</p></li>
			<li><p class="btn_blue">
					<a href="#" onclick="searchReport()">Search</a>
				</p></li>
			<li><p class="btn_blue">
					<a href="#" onclick="clearForm()">Clear</a>
				</p></li>
		</ul>
	</aside>
	<form id="attendReportForm">
		<table class="type1">
			<colgroup>
				<col style="width: 130px" />
				<col style="width: *" />
				<col style="width: 130px" />
				<col style="width: *" />
			</colgroup>
			<tr>
				<th>Org Code</th>
				<td><input class="search" type="text" name="orgCode"
					value="<c:if test="${orgCode != ' '}">${orgCode}</c:if>"
					<c:if test="${orgCode != ' '}">readonly</c:if> /></td>
				<th>Group Code</th>
				<td><input class="search" type="text" name="grpCode"
					value="<c:if test="${grpCode != ' '}">${grpCode}</c:if>"
					<c:if test="${grpCode != ' '}">readonly</c:if> /></td>
			</tr>
			<tr>
				<th>Dept Code</th>
				<td><input class="search" type="text" name="deptCode"
					value="<c:if test="${deptCode != ' '}">${deptCode}</c:if>"
					<c:if test="${deptCode != ' '}">readonly</c:if> /></td>
				<th>HP Code</th>
				<td><input class="search" type="text" name="memCode"
					value="<c:if test="${memLvl == 4}">${memCode}</c:if>" /></td>
			</tr>
			<tr>
				<th>Rank</th>
				<td colspan=3><select name="memLvl" class="search"></select></td>
			</tr>
		</table>
	</form>
	<article class="grid_wrap">
		<div id="reportBranch"></div>
	</article>
</section>

<div id="popup_wrap" class="popup_wrap hidden">
	<header class="pop_header">
		<h1>Add Reporting Branch</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#" id="addBrnchClose">Close</a>
				</p></li>
		</ul>
	</header>
	<section class="pop_body step1">
		<table class="type1">
			<colgroup>
				<col style="width: 130px" />
				<col style="width: *" />
			</colgroup>
			<tr>
				<th>HP Code</th>
				<td><input type="text" name="memCode" /></td>
			</tr>
		</table>
		<div style="text-align: center;">
			<p class="btn_blue2">
				<a href="#" id="confirmHP">Confirm</a>
			</p>
		</div>
	</section>
	<section class="pop_body step2 hidden">
		<h2>HP Organization Details</h2>
		<table class="type1">
			<colgroup>
				<col style="width: 130px" />
				<col style="width: *" />
				<col style="width: 130px" />
				<col style="width: *" />
				<col style="width: 130px" />
				<col style="width: *" />
			</colgroup>
			<tr>
				<th>HP Code</th>
				<td id="hpCode"></td>
				<th>HP Name</th>
				<td id="hpName" colspan="3"></td>
			</tr>
			<tr>
				<th>Dept Code</th>
				<td id="deptCode"></td>
				<th>Group Code</th>
				<td id="grpCode"></td>
				<th>Org Code</th>
				<td id="orgCode"></td>
			</tr>
		</table>
		<h2>Reporting Branch Details</h2>
		<table class="type1" id="reportBranchConfig">
			<colgroup>
				<col style="width: 130px" />
				<col style="width: *" />
				<col style="width: 130px" />
			</colgroup>
		</table>
		<p class="btn_blue2">
			<a href="#" id="confirmLocation">+ Add Location</a>
		</p>
		<hr style="width: 100%;" />
		<table class="type1">
			<tr>
				<th>Business Area</th>
				<td><select id="reportingBranches"></select></td>
			</tr>
		</table>
	</section>
</div>

<script>
    const rank = ["SGM", "GM", "SM", "HM", "HP"]
    document.querySelector(".search[name=memLvl]").innerHTML += "<option value=''>Choose One</option>"
    rank.forEach((r, i) => {
    	if (i > 0) {
		    document.querySelector(".search[name=memLvl]").innerHTML += "<option value=" + i + ">" + r +"</option>"
    	}
    })

    const branchesGrid = GridCommon.createAUIGrid('reportBranch', [
	    {
	        dataField: 'rank', headerText: 'Rank'
	    },
	    {
	        dataField: 'orgCode', headerText: 'Org Code'
	    },
	    {
	        dataField: 'grpCode', headerText: 'Group Code'
	    },
	    {
	        dataField: 'deptCode', headerText: 'Dept Code'
	    },
	    {
	        dataField: 'memCode', headerText: 'HP Code'
	    },
	    {
	        dataField: 'brnch', headerText: 'Reporting Branch'
	    }
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

    const clearForm = () => {
    	document.querySelectorAll(".search").forEach(e => {
    		if (e.attributes.value.textContent == "") {
    			e.value = ""
    		}
    	})
    }

    const addLocPopup = document.querySelector("#addBrnchClose").parentElement.parentElement.parentElement.parentElement.parentElement

    const addLocPop = () => {
    	addLocPopup.classList.toggle("hidden")
    }

    $("#addBrnchClose").click(() => {
    	addLocPopup.classList.toggle("hidden")
    	document.querySelector(".step1").classList.remove("hidden")
    	document.querySelector(".step2").classList.add("hidden")
    })

    const genLoc = (ls) => {
    	$("#reportBranchConfig .add").remove()
    	if (ls.length) {
	    	ls.forEach((l, i) => {
	            $("#reportBranchConfig").html($("#reportBranchConfig").html() + "<tr class='add'><th>Branch " + (i + 1) + "</th>" + "<td>" + l.attend_allow_branch_code + "</td><td><p class='btn_blue2' style='margin-right: 0;'><a href='#' onclick='removeBranch(`"+ l.attend_allow_branch_code + "`)'>Remove Branch</a></p></td></tr>")
	        })
    	} else {
    		$("#reportBranchConfig").html("<tr class='add'><th>Branches</th><td colspan='3'>All branches allowed</td></tr>")
    	}
    	listLocations(ls)
    }

    const removeBranch = (brnch) => {
    	Common.showLoader()
    	fetch("/attendance/removeLocation.do", {
    		method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({attendAllowBranchCode: brnch, memCode: $("#hpCode").text()})
    	})
    	.then(resp => resp.json())
    	.then(d => {
    		if (d.success) {
    			fetch("/attendance/selectHPReporting.do?memCode=" + $("#hpCode").text())
                .then(resp => resp.json())
                .then(d => {
                    genLoc(d.locations)
                })
                .finally(() => {
                    Common.removeLoader()
                })
    		} else {
    			Common.removeLoader()
    		}
    	})
    }

    const listLocations = (ls) => {
    	$("#reportingBranches").html("")
    	fetch("/attendance/getReportingBranch.do")
    	.then(resp => resp.json())
    	.then(d => {
    		d.forEach((e) => {
    			if (ls.filter(i => i.attend_allow_branch_id == e.meetPointId).length == 0) {
		    		$("#reportingBranches").html($("#reportingBranches").html() + "<option value=" + e.meetPointId + ">" + e.name + "</option>")
    			}
    		})
    	})
    }

    document.querySelector("#confirmHP").onclick = () => {
        const memCode = document.querySelector(".step1 input[name=memCode]").value
        if (memCode.trim().length == 0) {
        	Common.alert("Kindly keyin HP code")
            return
        }
        Common.showLoader()
        fetch("/attendance/selectHPReporting.do?memCode=" + memCode)
        .then(resp => resp.json())
        .then(d => {
        	d.memCode && addLocPopup.querySelectorAll("section").forEach(e => {
                e.classList.toggle("hidden")
            })
            $("#hpCode").text(d.memCode)
            $("#hpName").text(d.name)
            $("#deptCode").text(d.deptCode)
            $("#grpCode").text(d.grpCode)
            $("#orgCode").text(d.orgCode)
            genLoc(d.locations)
        })
        .finally(() => {
        	Common.removeLoader()
        })
    }

    $("#confirmLocation").click(() => {
    	const select = document.querySelector("#reportingBranches")
    	Common.showLoader()
    	fetch("/attendance/addLocation.do", {
    		method: "POST",
    		headers: {"Content-Type": "application/json"},
    		body: JSON.stringify({id: select.value, name: select.options[select.selectedIndex].text, code: $("#hpCode").text()})
    	})
    	.then(resp => resp.json())
    	.then(d => {
   			if (d.success) {
	    		fetch("/attendance/selectHPReporting.do?memCode=" + $("#hpCode").text())
	    		.then(resp => resp.json())
	    		.then(d => {
	    			genLoc(d.locations)
	    		})
	    		.finally(() => {
	    			Common.removeLoader()
	    		})
   			}
    	})
    })

    const searchReport = () => {
    	if ($(".search[name=orgCode]").val() || $(".search[name=grpCode]").val() || $(".search[name=deptCode]").val() || $(".search[name=memCode]").val()) {
	    	fetch("/attendance/getAllReporting.do?orgCode=" + $(".search[name=orgCode]").val() + "&grpCode=" + $(".search[name=grpCode]").val() + "&deptCode=" + $(".search[name=deptCode]").val() + "&memCode=" + $(".search[name=memCode]").val() + "&memLvl=" + $(".search[name=memLvl]").val())
	    	.then(resp => resp.json())
	    	.then(d => {
	    		AUIGrid.setGridData(branchesGrid, d.map(p => {
	    			return p.locations.map(l => {
	    				return {rank: p.rank ? rank[p.rank] : "", orgCode: p.orgCode, grpCode: p.grpCode, deptCode: p.deptCode, memCode: p.memCode, brnch: l.attend_allow_branch_code}
	    			})
	    		}).flat())
	    	})
    	} else {
    		Common.alert("Kindly limit searching criteria")
    	}
    }
</script>