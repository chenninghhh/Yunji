#指定服务提供者
provider "alicloud" {
}
#创建安全组
resource "alicloud_security_group" "group" {
  name        = "tf_test_foo"
  description = "foo"
  vpc_id      = alicloud_vpc.vpc.id
}
#创建一个vpc专用网络
resource "alicloud_vpc" "vpc" {
  name       = "test_vpc"
  cidr_block = "172.16.0.0/16"
}
#虚拟交换机
resource "alicloud_vswitch" "vswitch" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "172.16.0.0/24"
  vswitch_name      = "test_vpc"
  availability_zone = "cn-beijing-b"
}
#创建ECS实例
resource "alicloud_instance" "instance" {
  # cn-beijing
  availability_zone = "cn-beijing-b"
  security_groups   = alicloud_security_group.group.*.id

  # series III
  instance_type              = "ecs.n2.small"
  image_id                   = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
  instance_name              = "test_foo"  
  vswitch_id                 = alicloud_vswitch.vswitch.id
  internet_max_bandwidth_out = 10
}
