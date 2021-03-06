<body>
	<div class="x-nav">
		<span class="layui-breadcrumb">
		  <a><cite>首页</cite></a>
		  <a><cite>小说管理</cite></a>
		  <a><cite>章节列表</cite></a>
		</span>
		<a class="layui-btn layui-btn-small" style="line-height: 1.6em; margin-top: 3px; float: right"  href="javascript:location.replace(location.href);" title="刷新"><i class="layui-icon" style="line-height:30px">ဂ</i></a>
	</div>
	<div class="x-body">
		<form class="layui-form x-center" action="" style="width:80%">
			<div class="layui-form-pane" style="margin-top: 15px;">
			  <div class="layui-form-item">
				<div class="layui-input-inline">
				  <input type="text" name="q" placeholder="请输入章节名称" autocomplete="off" class="layui-input" value="{{.Search.q}}">
				  <input type="hidden" name="novid" value="{{.Search.novId}}">
				</div>
				<div class="layui-input-inline" style="width:80px">
					<button class="layui-btn"  lay-submit="" lay-filter="sreach"><i class="layui-icon">&#xe615;</i></button>
				</div>
			  </div>
			</div> 
		</form>
		<xblock>
			<button class="layui-btn layui-btn-danger" onclick="del_all()"><i class="layui-icon">&#xe640;</i>批量删除</button>
			<button class="layui-btn" onclick="x_admin_show('添加章节', '{{urlfor "admin.ChapterController.Add" "novid" .Search.novId}}')"><i class="layui-icon">&#xe608;</i>添加</button>
			<span class="x-right" style="line-height:40px">共有数据：{{.ChaptersCount}} 条</span>
		</xblock>
		<table class="layui-table">
			<thead>
				<tr>
					<th><input type="checkbox" name="" value="" class="all-select"></th>
					<th>编号</th>
					<th>章节标题</th>
					<th>浏览次数</th>
					<th>章节状态</th>
					<th>采集重试次数</th>
					<th>更新时间</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
			{{range .Chapters}}
				<tr>
					<td><input type="checkbox" value="{{.Id}}" name="" class="all-x-select"></td>
					<td>{{.ChapterNo}}</td>
					<td><a href="{{urlfor "home.BookController.Detail" "id" .Id "novid" .NovId}}" target="_blank">{{.Title}}</a></td>
					<td>{{.Views}}</td>
					<td>{{str2html .StatusName}}</td>
					<td>{{.TryViews}}</td>
					<td>{{datetime .CreatedAt "2006-01-02 15:04:05"}}</td>
					<td class="td-manage">
						<a title="编辑章节" href="javascript:;" onclick="x_admin_show('编辑章节', {{urlfor "admin.ChapterController.Edit" "id" .Id "novid" $.Search.novId}})" class="ml-5" style="text-decoration:none">
							<i class="layui-icon">&#xe642;</i>
						</a>
						<a title="删除" href="javascript:;" onclick="del(this,'{{.Id}}', '{{.Title}}')" style="text-decoration:none">
							<i class="layui-icon">&#xe640;</i>
						</a>
					</td>
				</tr>
			{{end}}
			</tbody>
		</table>
		<div id="page"></div>
	</div>
	<script>
		window.onload = function() {
			layui.use(['laypage', 'layer'], function() {
				$ = layui.jquery; //jquery
				layer = layui.layer; //弹出层

				// 分页
				layui.laypage({
					cont: 'page',
					pages: {{.MaxPages}},
					last: {{.MaxPages}},
					curr: {{.Search.p}},
					first: 1,
					prev: '<em><</em>',
					next: '<em>></em>',
					skip: false,
					jump: function (obj, first) {
						if (first != true) {
							window.location.href = {{urlfor "admin.ChapterController.Index"}} + "?p=" + obj.curr + "&q={{.Search.q}}&novid={{.Search.novId}}";
						}
					}
				}); 
			});
		}

		// 批量删除提交
		function del_all() {
			layer.confirm('确认要删除吗？', function(index) {
                var ids = get_list_ids('all-x-select');
				//发异步删除数据
				ajax_post({{urlfor "admin.ChapterController.DeleteBatch"}}, {ids: ids, novid: {{.Search.novId}}}, "", true, false);
			});
		}

		// 删除
		function del(obj, id, name) {
			layer.confirm('确认要删除吗？', function(index) {
				$(obj).parents("tr").remove();

				//发异步删除数据
				ajax_post({{urlfor "admin.ChapterController.Delete"}}, {id: id, name: name, novid: {{.Search.novId}}}, "", true, false);
			});
		}
	</script>
</body>
