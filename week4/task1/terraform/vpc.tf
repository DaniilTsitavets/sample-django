resource "aws_vpc" "django_vpc" {
  cidr_block = var.django_vpc_cidr
}
resource "aws_subnet" "django_public_subnet" {
  count = length(var.django_public_subnet_cidr)

  vpc_id            = aws_vpc.django_vpc.id
  cidr_block        = var.django_public_subnet_cidr[count.index % length(var.django_subnet_az)]
  availability_zone = var.django_subnet_az[count.index]

  tags = {
    name = "public_subnet_${[count.index]}"
  }
}
resource "aws_subnet" "django_private_subnet" {
  count = length(var.django_private_subnet_cidr)

  vpc_id            = aws_vpc.django_vpc.id
  cidr_block        = var.django_private_subnet_cidr[count.index % length(var.django_subnet_az)]
  availability_zone = var.django_subnet_az[count.index]

  tags = {
    name = "private_subnet_${[count.index]}"
  }
}
resource "aws_route_table" "django_rt" {
  vpc_id = aws_vpc.django_vpc.id

  route = {
    cidr_block = ["0.0.0.0/0"]
    gateway_id = aws_internet_gateway.django_igw.id
  }
}

resource "aws_route_table_association" "django_public_association" {
  count          = length(aws_subnet.django_public_subnet)
  subnet_id      = aws_subnet.django_public_subnet.id
  route_table_id = aws_route_table.django_rt
}

resource "aws_internet_gateway" "django_igw" {
  vpc_id = aws_vpc.django_vpc.id
}
